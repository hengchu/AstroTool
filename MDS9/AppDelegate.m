//
//  AppDelegate.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/7/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MDSCenterViewController.h"
#import "MDSRightViewController.h"
#import "MDSMenuController.h"
#import "MDSTitleBarAccessoryViewController.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AppDelegate ()

@property (nonatomic, strong) MDSCenterViewController *mainVC;
@property (nonatomic, strong) MDSRightViewController *rightVC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 600, 800)
                                                    styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
                                                      backing:NSBackingStoreBuffered
                                                        defer:NO];
  
  self.mainVC = [[MDSCenterViewController alloc] initWithNibName:@"MDSMainViewController" bundle:[NSBundle mainBundle]];
  self.rightVC = [[MDSRightViewController alloc] initWithNibName:@"MDSRightViewController" bundle:[NSBundle mainBundle]];
  self.rightVC.centerVC = self.mainVC;
  
  MDSTitleBarAccessoryViewController *titleVC = [[MDSTitleBarAccessoryViewController alloc] initWithNibName:@"MDSTitleBarAccessoryViewController" bundle:[NSBundle mainBundle]];
  [self.window addTitlebarAccessoryViewController:titleVC];
  
  NSNib *menuNib                    = [[NSNib alloc] initWithNibNamed:@"MDSMenu" bundle:[NSBundle mainBundle]];
  MDSMenuController *menuController = [[MDSMenuController alloc] init];
  [menuNib instantiateWithOwner:menuController topLevelObjects:nil];
  
  menuController.delegate = self.mainVC;
  
  NSView *contentView = [[NSView alloc] initWithFrame:self.window.frame];
  self.window.contentView = contentView;
  self.mainVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  self.rightVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:self.mainVC.view];
  [contentView addSubview:self.rightVC.view];
  
  [self.mainVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeRight];
  [self.rightVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeLeft];
  [self.rightVC.view autoSetDimension:ALDimensionWidth toSize:300];
  [self.mainVC.view autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightVC.view];
  
  [[NSApplication sharedApplication] setMainMenu:menuController.menu];
  
  self.window.titleVisibility = NSWindowTitleHidden;
  [self.window makeKeyAndOrderFront:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

@end
