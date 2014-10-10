//
//  AppDelegate.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/7/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MDSCenterViewController.h"
#import "MDSMenuController.h"
#import "MDSTitleBarAccessoryViewController.h"
#import <PureLayout/PureLayout.h>

@interface AppDelegate ()

@property (nonatomic, strong) MDSCenterViewController *mainVC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 600, 800)
                                                    styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
                                                      backing:NSBackingStoreBuffered
                                                        defer:NO];
  
  self.mainVC = [[MDSCenterViewController alloc] initWithNibName:@"MDSMainViewController" bundle:[NSBundle mainBundle]];
  
  MDSTitleBarAccessoryViewController *titleVC = [[MDSTitleBarAccessoryViewController alloc] initWithNibName:@"MDSTitleBarAccessoryViewController" bundle:[NSBundle mainBundle]];
  [self.window addTitlebarAccessoryViewController:titleVC];
  
  NSNib *menuNib                    = [[NSNib alloc] initWithNibNamed:@"MDSMenu" bundle:[NSBundle mainBundle]];
  MDSMenuController *menuController = [[MDSMenuController alloc] init];
  [menuNib instantiateWithOwner:menuController topLevelObjects:nil];
  
  menuController.delegate = self.mainVC;
  self.window.contentView = self.mainVC.view;
  [[NSApplication sharedApplication] setMainMenu:menuController.menu];
  
  [self.window makeKeyAndOrderFront:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

@end
