//
//  NSString_C___Glue.h
//  Additions
//
//  Created by Braeden Hintze on 5/12/17.
//  Copyright © 2017 Braeden Hintze. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string>

@interface NSString (cpp_glue)

/// Creates a c++ u16string copy of the receiver.
-(std::string) cppString;

@end
