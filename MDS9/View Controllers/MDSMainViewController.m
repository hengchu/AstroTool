//
//  MDSMainViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/16/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSMainViewController.h"
#import "MDSCenterViewController.h"
#import "MDSRightViewController.h"
#import "MDSTheme.h"
#import "MDSIconContainerView.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MDSMainViewController ()

@property (nonatomic, strong) MDSCenterViewController *centerVC;
@property (nonatomic, strong) MDSRightViewController *rightVC;

@end

@implementation MDSMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do view setup here.
  
  // Sub view/vc allocation
  self.centerVC =
      [[MDSCenterViewController alloc] initWithNibName:@"MDSCenterViewController"
                                                bundle:[NSBundle mainBundle]];
  self.rightVC =
      [[MDSRightViewController alloc] initWithNibName:@"MDSRightViewController"
                                               bundle:[NSBundle mainBundle]];

  NSView *verticalSeparator = [NSView newAutoLayoutView];
  NSView *iconContainerHorizontalSeparator = [NSView newAutoLayoutView];
  MDSIconContainerView *iconContainer = [[MDSIconContainerView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  iconContainer.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Adding subviews to self.view
  [self.view addSubview:verticalSeparator];
  [self.view addSubview:iconContainerHorizontalSeparator];
  [self.view addSubview:iconContainer];
  
  self.rightVC.centerVC = self.centerVC;

  self.centerVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  self.rightVC.view.translatesAutoresizingMaskIntoConstraints  = NO;
  
  [self.view addSubview:self.centerVC.view];
  [self.view addSubview:self.rightVC.view];
  
  // Constraints
  [self.centerVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero
                                               excludingEdge:ALEdgeRight];
  
  [self.rightVC.view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [self.rightVC.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
  [self.rightVC.view autoSetDimension:ALDimensionWidth toSize:300];

  [self.centerVC.view autoPinEdge:ALEdgeRight
                           toEdge:ALEdgeLeft
                           ofView:verticalSeparator];
  
  [iconContainer autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
  [iconContainer autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [iconContainer autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.rightVC.view];
  [iconContainer autoSetDimension:ALDimensionHeight toSize:30.0f];
  
  [self.rightVC.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconContainerHorizontalSeparator];
  
  [iconContainerHorizontalSeparator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [iconContainerHorizontalSeparator autoMatchDimension:ALDimensionWidth
                                           toDimension:ALDimensionWidth
                                                ofView:self.rightVC.view];
  [iconContainerHorizontalSeparator autoSetDimension:ALDimensionHeight toSize:1];
  [iconContainerHorizontalSeparator autoPinEdge:ALEdgeTop
                                         toEdge:ALEdgeBottom
                                         ofView:iconContainer];
  
  [verticalSeparator autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
  [verticalSeparator autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
  [verticalSeparator autoPinEdge:ALEdgeRight
                          toEdge:ALEdgeLeft
                          ofView:self.rightVC.view];
  [verticalSeparator autoSetDimension:ALDimensionWidth toSize:1];
  
  verticalSeparator.wantsLayer            = YES;
  verticalSeparator.layer.backgroundColor = [MDSTheme separatorColor].CGColor;
  iconContainerHorizontalSeparator.wantsLayer            = YES;
  iconContainerHorizontalSeparator.layer.backgroundColor = [MDSTheme separatorColor].CGColor;
  
  NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  [button setImage:[NSImage imageNamed:@"HeaderIconNormal"]];
  [button setAlternateImage:[NSImage imageNamed:@"HeaderIconHighlighted"]];
  [button setButtonType:NSToggleButton];
  button.bordered = NO;
  
  NSButton *button1 = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  [button1 setImage:[NSImage imageNamed:@"HeaderIconNormal"]];
  [button1 setAlternateImage:[NSImage imageNamed:@"HeaderIconHighlighted"]];
  [button1 setButtonType:NSToggleButton];
  button1.bordered = NO;
  
  NSButton *button2 = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  [button2 setImage:[NSImage imageNamed:@"HeaderIconNormal"]];
  [button2 setAlternateImage:[NSImage imageNamed:@"HeaderIconHighlighted"]];
  [button2 setButtonType:NSToggleButton];
  button2.bordered = NO;
  
  [iconContainer addIcon:button];
  [iconContainer addIcon:button1];
  [iconContainer addIcon:button2];
}

- (void)didOpenFileWithURL:(NSURL *)url
{
  [self.centerVC openFileWithURL:url];
}

@end
