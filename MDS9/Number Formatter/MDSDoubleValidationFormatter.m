//
//  MDSDoubleValidationFormatter.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/31/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSDoubleValidationFormatter.h"

@implementation MDSDoubleValidationFormatter

- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString *__autoreleasing *)newString
            errorDescription:(NSString *__autoreleasing *)error
{
  if ([partialString length] == 0) return YES;
  
  NSScanner *scanner = [NSScanner scannerWithString:partialString];
  
  if (!([scanner scanDouble:NULL] && [scanner isAtEnd])) {
    return NO;
  } else {
    return YES;
  }
}

@end
