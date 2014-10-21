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
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MDSMainViewController ()

@property (nonatomic, strong) MDSCenterViewController *centerVC;
@property (nonatomic, strong) MDSRightViewController *rightVC;

@end

@implementation MDSMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
  
  self.centerVC = [[MDSCenterViewController alloc] initWithNibName:@"MDSCenterViewController" bundle:[NSBundle mainBundle]];
  self.rightVC = [[MDSRightViewController alloc] initWithNibName:@"MDSRightViewController" bundle:[NSBundle mainBundle]];
  
  NSView *verticalSeparator = [NSView newAutoLayoutView];
  [self.view addSubview:verticalSeparator];
  
  self.rightVC.centerVC = self.centerVC;
  
  self.centerVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  self.rightVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.centerVC.view];
  [self.view addSubview:self.rightVC.view];
  
  [self.centerVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeRight];
  [self.rightVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeLeft];
  [self.rightVC.view autoSetDimension:ALDimensionWidth toSize:300];
  [self.centerVC.view autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:verticalSeparator];
  
  [verticalSeparator autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
  [verticalSeparator autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
  [verticalSeparator autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightVC.view];
  [verticalSeparator autoSetDimension:ALDimensionWidth toSize:1];
  verticalSeparator.wantsLayer = YES;
  verticalSeparator.layer.backgroundColor = [MDSTheme separatorColor].CGColor;
}

- (void)didOpenFileWithURL:(NSURL *)url
{
  [self.centerVC openFileWithURL:url];
}

@end
