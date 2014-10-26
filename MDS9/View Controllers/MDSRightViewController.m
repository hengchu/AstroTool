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
#import <ReactiveCocoa/RACEXTScope.h>

@interface MDSRightViewController ()
@property (nonatomic, strong) NSMutableArray *sideViewControllers;
@property (nonatomic, strong) NSMutableArray *sideViews;
@end

@implementation MDSRightViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do view setup here.
  
  self.view.wantsLayer = YES;
  self.view.layer.backgroundColor = [MDSTheme panelColor].CGColor;
  
  self.sideViews = [NSMutableArray array];
  self.sideViewControllers = [NSMutableArray array];
  
  MDSHeaderTableViewController *tableVC = [[MDSHeaderTableViewController alloc] init];
  
  @weakify(self)
  [self addSectionWithViewController:tableVC
                               title:@"Headers"
                     preferredHeight:300
                          setupBlock:^(NSViewController *vc) {
    @strongify(self)
    [RACObserve(self.centerVC, currentOpenFile) subscribeNext:^(id x) {
      tableVC.openFile = x;
    }];
  }];
}

#pragma mark - Public API

- (void)addSectionWithViewController:(NSViewController *)vc
                               title:(NSString *)title
                     preferredHeight:(CGFloat)height
                          setupBlock:(void(^)(NSViewController *vc))vcSetupBlock

{
  [self addSectionWithView:vc.view title:title preferredHeight:height];
  
  if (vcSetupBlock) {
    vcSetupBlock(vc);
  }
  
  [self.sideViewControllers addObject:vc];
}

- (void)addSectionWithView:(NSView *)view
                     title:(NSString *)title
           preferredHeight:(CGFloat)height
{
  NSView *previousView = [self.sideViews lastObject];
  
  MDSDisclosureContentViewController *disclosureVC = [[MDSDisclosureContentViewController alloc] init];
  disclosureVC.disclosedView = view;
  disclosureVC.header = title;
  
  [self.view addSubview:disclosureVC.view];
  
  [ALView autoSetPriority:600 forConstraints:^{
    [disclosureVC.view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [disclosureVC.view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [disclosureVC.view autoSetDimension:ALDimensionHeight toSize:height];
  }];
  
  (previousView == nil)
      ? [disclosureVC.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0]
      : [disclosureVC.view autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeBottom
                                ofView:previousView
                            withOffset:1.0];
  
  NSView *separator = [NSView newAutoLayoutView];
  [self.view addSubview:separator];
  [separator autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
  [separator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [separator autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:disclosureVC.view];
  [separator autoSetDimension:ALDimensionHeight toSize:1];
  separator.wantsLayer = YES;
  separator.layer.backgroundColor = [MDSTheme separatorColor].CGColor;
  
  [self.sideViews addObject:view];
}

@end
