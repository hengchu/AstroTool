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
#import <PureLayout/PureLayout.h>

@interface AppDelegate ()

@property (nonatomic, strong) MDSMainViewController *mainVC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  self.window = [[INAppStoreWindow alloc] initWithContentRect:NSMakeRect(0, 0, 600, 800)
                                                    styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
                                                      backing:NSBackingStoreBuffered
                                                        defer:NO];
  // Titlebar styling.
  self.window.titleBarHeight         = 44.0f;
  self.window.showsBaselineSeparator = NO;
  self.window.titleBarStartColor     = [NSColor colorWithCalibratedWhite:0.8 alpha:1.0];
  self.window.titleBarEndColor       = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];

  self.mainVC = [[MDSMainViewController alloc] initWithNibName:@"MDSMainViewController" bundle:[NSBundle mainBundle]];
  
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
