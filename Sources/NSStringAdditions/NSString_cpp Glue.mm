//
//  C++ Glue.m
//  Additions
//
//  Created by Braeden Hintze on 5/12/17.
//  Copyright © 2017 Braeden Hintze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Additions/NSString_cpp Glue.hh>

@implementation NSString (cpp_glue)

/// Creates a c++ u16string copy of the receiver.
///
/// Requires that the receiver is expressible in UTF-8.
-(std::string) cppString
{
	return std::string([self cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
