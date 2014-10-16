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
#import "MDSHeaderDisclosureView.h"
#import <PureLayout/PureLayout.h>
#import "MDSHeaderTableViewController.h"

@interface MDSRightViewController ()
@end

@implementation MDSRightViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do view setup here.
  
  
  MDSHeaderTableViewController *tableVC = [[MDSHeaderTableViewController alloc] init];
  [self.view addSubview:tableVC.view];
  [tableVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero];
  
  [RACObserve(self.centerVC, currentOpenFile) subscribeNext:^(id x) {
    tableVC.openFile = x;
  }];
}


@end
