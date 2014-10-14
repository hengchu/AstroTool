//
//  NSArray+Map.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/10/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
  
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [result addObject:block(obj, idx)];
  }];
  
  return result;
}

@end
