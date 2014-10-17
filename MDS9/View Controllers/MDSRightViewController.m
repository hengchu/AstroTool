//
//  MDSRightViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/10/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSRightViewController.h"
#import "NSArray+Map.h"
#import "MDSHeaderTableRowView.h"
#import "MDSTheme.h"
#import "MDSDisclosureView.h"
#import <PureLayout/PureLayout.h>
#import "MDSHeaderTableViewController.h"
#import "MDSDisclosureContentViewController.h"

@interface MDSRightViewController ()
@property (weak) IBOutlet NSLayoutConstraint *headerContainerHeightConstraint;
@property (weak) IBOutlet NSView *headerContainer;
@end

@implementation MDSRightViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do view setup here.
  
  self.view.wantsLayer = YES;
  self.view.layer.backgroundColor = [MDSTheme panelColor].CGColor;
  
  MDSHeaderTableViewController *tableVC = [[MDSHeaderTableViewController alloc] init];
  
  [RACObserve(self.centerVC, currentOpenFile) subscribeNext:^(id x) {
    tableVC.openFile = x;
  }];
  
  // This block of code sets up the display of header table view
  MDSDisclosureContentViewController *disclosureVC = [[MDSDisclosureContentViewController alloc] init];
  disclosureVC.disclosedView = tableVC.view;
  
  [self.view addSubview:disclosureVC.view];
  
  [ALView autoSetPriority:600 forConstraints:^{
    [disclosureVC.view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [disclosureVC.view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [disclosureVC.view autoSetDimension:ALDimensionHeight toSize:400];
  }];
  [disclosureVC.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
  
  NSView *separator = [NSView newAutoLayoutView];
  [self.view addSubview:separator];
  [separator autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
  [separator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [separator autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:disclosureVC.view];
  [separator autoSetDimension:ALDimensionHeight toSize:1];
  separator.wantsLayer = YES;
  separator.layer.backgroundColor = [MDSTheme separatorColor].CGColor;
}


@end
