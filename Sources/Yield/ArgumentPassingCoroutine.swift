import Dispatch

private let coroutineQueue = DispatchQueue(label: "argument-passing-coroutine", attributes: .concurrent)

private enum TransportStorage<Argument, Element> {
    case Input(Argument)
    case Output(Element)
}

public class ArgumentPassingCoroutine<Argument, Element> {
    private let callerReady = DispatchSemaphore(value: 0)
    private let coroutineReady = DispatchSemaphore(value: 0)
    private var done: Bool = false
    private var transportStorage: TransportStorage<Argument, Element>?
    
    public typealias Yield = (Element) -> Argument
    public init(implementation: @escaping (Yield) -> ())
	{
		// Only start this process; don't synchronously run it all within `init`.
        coroutineQueue.async()
		{
            // Don't start coroutine until first call.
			_ = self.callerReady.wait(timeout: .distantFuture)
            
			// Run `implementation`, providing this `yield` function.
            implementation
			{
				next in
                // Place element in transport storage, and let caller know it's ready.
                self.transportStorage = .Output(next)
                self.coroutineReady.signal()
                
                // Don't continue coroutine until next call.
                _ = self.callerReady.wait(timeout: .distantFuture)
                
                // Caller sent the next argument, so let's continue.
                defer { self.transportStorage = nil }
                guard case let .some(.Input(input)) = self.transportStorage else { fatalError() }
                return input
            }
            
            // The coroutine is forever over, so let's let the caller know.
            self.done = true
            self.coroutineReady.signal()
        }
    }
    
    public func next(argument: Argument) -> Element? {
        // Make sure work is happening before we wait.
        guard !done else { return nil }
        
        // Return to the coroutine, passing the argument.
        transportStorage = .Input(argument)
        callerReady.signal()
		
        // Wait until it has finished.
        _ = coroutineReady.wait(timeout: .distantFuture)
        
        // Return to the caller the result, then clear it.
        defer { transportStorage = nil }
        guard case let .some(.Output(output)) = transportStorage else { return nil }
        return output
    }
}
