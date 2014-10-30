//
//  AppDelegate.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/7/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MDSMainViewController.h"
#import "MDSMenuController.h"
#import "MDSTitleBarAccessoryViewController.h"
#import "MDSTheme.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Transformation Functions/MDSTransformationFunctions.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  
#ifdef DEBUG
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
#endif
  
  self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 800, 1280)
                                                    styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
                                                      backing:NSBackingStoreBuffered
                                                        defer:NO];
  
  NSNib *menuNib                    = [[NSNib alloc] initWithNibNamed:@"MDSMenu" bundle:[NSBundle mainBundle]];
  MDSMenuController *menuController = [[MDSMenuController alloc] init];
  [menuNib instantiateWithOwner:menuController topLevelObjects:nil];
  
  MDSMainViewController *mainVC = [[MDSMainViewController alloc] init];
  menuController.delegate = mainVC;
  [[NSApplication sharedApplication] setMainMenu:menuController.menu];
  
  self.window.contentViewController = mainVC;
  self.window.titleVisibility = NSWindowTitleHidden;
  [self.window makeKeyAndOrderFront:self];
  
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

@end
