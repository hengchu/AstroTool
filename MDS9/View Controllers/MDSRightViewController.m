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
@end

@implementation MDSRightViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do view setup here.
  
  MDSHeaderTableViewController *tableVC = [[MDSHeaderTableViewController alloc] init];
  
  [RACObserve(self.centerVC, currentOpenFile) subscribeNext:^(id x) {
    tableVC.openFile = x;
  }];
  
  self.view.wantsLayer = YES;
  self.view.layer.backgroundColor = [MDSTheme panelColor].CGColor;
  
  
  NSView *disclosureViewContainer = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 400)];
  [self.view addSubview:disclosureViewContainer];
  MDSDisclosureContentViewController *disclosureVC = [[MDSDisclosureContentViewController alloc] init];
  disclosureVC.disclosedView = tableVC.view;
  [disclosureViewContainer addSubview:disclosureVC.view];
  [ALView autoSetPriority:600 forConstraints:^{
    [disclosureVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeTop];
  }];
  [disclosureVC.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
}


@end
