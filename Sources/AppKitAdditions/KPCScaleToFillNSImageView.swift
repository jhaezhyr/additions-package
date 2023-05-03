//
//  KPCScaleToFillNSImageView.swift
//  Additions
//
//  Created by Braeden Hintze on 6/2/15.
//  Copyright (c) 2015 Braeden Hintze. All rights reserved.
//

import Cocoa
import CoreGraphicsAdditions


class KPCScaleToFillNSImageView: NSImageView
{
	var knowsImage	= false
	
	override var imageScaling:		NSImageScaling
	{
		didSet
		{
			// This is the only one that will work.
			super.imageScaling = NSImageScaling.scaleAxesIndependently
		}
	}
	
	
	init()
	{
		super.init(frame: CGRect(0, 0, 0, 0))
		imageScaling = NSImageScaling.scaleAxesIndependently
	}
	

	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		imageScaling = NSImageScaling.scaleAxesIndependently
	}
	
	
	override init(frame frameRect: NSRect)
	{
		super.init(frame: frameRect)
		imageScaling = NSImageScaling.scaleAxesIndependently
	}
	
	
	override func	awakeFromNib()
	{
		let newImage = image
		image = newImage
	}
	
	
	override var image:			NSImage?
	{
		didSet
		{
			if (image == nil) || (knowsImage)
			{
				return
			}
			
			func	drawAspectFillImage(_ dstRect: NSRect) -> Bool
			{
				let imageSize		= image!.size
				let imageViewSize	= bounds.size // Yes, do not use dstRect.
				var newImageSize	= imageSize

				let imageAspectRatio		= imageSize.height / imageSize.width
				let imageViewAspectRatio	= imageViewSize.height / imageViewSize.width

				if (imageAspectRatio < imageViewAspectRatio)
				{
					// Image is more horizontal than the view. Image left and right borders need to be cropped.
					newImageSize.width = imageSize.height / imageViewAspectRatio;
				}
				else
				{
					// Image is more vertical than the view. Image top and bottom borders need to be cropped.
					newImageSize.height = imageSize.width * imageViewAspectRatio;
				}

				let srcRect = NSRect(	origin: NSPoint(x:	imageSize.width / 2.0 - newImageSize.width / 2.0,
														y:	imageSize.height / 2.0 - newImageSize.height / 2.0	),
										size:	newImageSize	)

				NSGraphicsContext.current!.imageInterpolation = .high

				self.image!.draw(
									in: dstRect, // Interestingly, here needs to be dstRect and not self.bounds
						from:	srcRect,
						operation:	.sourceOver,
						fraction:	1.0,
					respectFlipped:	true,
							hints:	[NSImageRep.HintKey.interpolation : NSNumber(value: UInt32(NSImageInterpolation.high.rawValue) as UInt32)]	)

				return true
			}
			
			let scaleToFillImage: NSImage	= NSImage(	size:			self.bounds.size,
														flipped:		false,
														drawingHandler:	drawAspectFillImage	)

			scaleToFillImage.cacheMode = .never // Hence it will automatically redraw with new frame size of the image view.
			
			knowsImage = true
			image = scaleToFillImage
			
			knowsImage = false
		}
	}
}
