//
//  main.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/7/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    AppDelegate *appdelegate = [AppDelegate new];
    [NSApplication sharedApplication];
    [[NSApplication sharedApplication] setDelegate:appdelegate];
    [NSApp run];
  }
  return EXIT_SUCCESS;
}
