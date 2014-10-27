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
#import "MDSHeaderTableViewController.h"
#import "MDSThumbnailView.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MDSMainViewController ()

@property (nonatomic, strong) MDSCenterViewController *centerVC;
@property (nonatomic, strong) NSView *rightVCContainer;
@property (nonatomic, strong) NSView *verticalSeparator;
@property (nonatomic, strong) NSView *iconContainerHorizontalSeparator;
@property (nonatomic, strong) MDSIconContainerView *iconContainer;
@property (nonatomic, strong) NSMutableDictionary *iconToRightVC;

@end

@implementation MDSMainViewController

#pragma mark - Subview setup/creation

- (void)createCenterVC
{
  self.centerVC =
  [[MDSCenterViewController alloc] initWithNibName:@"MDSCenterViewController"
                                            bundle:[NSBundle mainBundle]];
  self.centerVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.centerVC.view];
}

- (void)createSeparators
{
  self.verticalSeparator = [NSView newAutoLayoutView];
  self.iconContainerHorizontalSeparator = [NSView newAutoLayoutView];
  [self.view addSubview:self.verticalSeparator];
  [self.view addSubview:self.iconContainerHorizontalSeparator];
  
  self.verticalSeparator.wantsLayer            = YES;
  self.verticalSeparator.layer.backgroundColor = [MDSTheme separatorColor].CGColor;
  self.iconContainerHorizontalSeparator.wantsLayer            = YES;
  self.iconContainerHorizontalSeparator.layer.backgroundColor = [MDSTheme separatorColor].CGColor;

}

- (void)createIconContainer
{
  self.iconContainer = [[MDSIconContainerView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  self.iconContainer.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.iconContainer];
}

- (void)createInterViewConstraints
{
  // Constraints
  [self.centerVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero
                                               excludingEdge:ALEdgeRight];
  
  [self.rightVCContainer autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [self.rightVCContainer autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
  [self.rightVCContainer autoSetDimension:ALDimensionWidth toSize:300];
  [self.rightVCContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.iconContainerHorizontalSeparator];
  
  [self.centerVC.view autoPinEdge:ALEdgeRight
                           toEdge:ALEdgeLeft
                           ofView:self.verticalSeparator];
  
  [self.iconContainer autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
  [self.iconContainer autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [self.iconContainer autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.rightVCContainer];
  [self.iconContainer autoSetDimension:ALDimensionHeight toSize:30.0f];
  
  
  [self.iconContainerHorizontalSeparator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [self.iconContainerHorizontalSeparator autoMatchDimension:ALDimensionWidth
                                                toDimension:ALDimensionWidth
                                                     ofView:self.rightVCContainer];
  [self.iconContainerHorizontalSeparator autoSetDimension:ALDimensionHeight toSize:1];
  [self.iconContainerHorizontalSeparator autoPinEdge:ALEdgeTop
                                              toEdge:ALEdgeBottom
                                              ofView:self.iconContainer];
  
  [self.verticalSeparator autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
  [self.verticalSeparator autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
  [self.verticalSeparator autoPinEdge:ALEdgeRight
                               toEdge:ALEdgeLeft
                               ofView:self.rightVCContainer];
  [self.verticalSeparator autoSetDimension:ALDimensionWidth toSize:1];
}

- (void)createRightVCContainer
{
  self.rightVCContainer = [NSView newAutoLayoutView];
  [self.view addSubview:self.rightVCContainer];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self createRightVCContainer];
  [self createCenterVC];
  [self createSeparators];
  [self createIconContainer];
  [self createInterViewConstraints];
  self.iconToRightVC = [NSMutableDictionary dictionary];
  
  NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  [button setImage:[NSImage imageNamed:@"HeaderIconNormal"]];
  [button setAlternateImage:[NSImage imageNamed:@"HeaderIconHighlighted"]];
  button.bordered = NO;
  
  NSButton *button1 = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  [button1 setImage:[NSImage imageNamed:@"HeaderIconNormal"]];
  [button1 setAlternateImage:[NSImage imageNamed:@"HeaderIconHighlighted"]];
  button1.bordered = NO;
  
  NSButton *button2 = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  [button2 setImage:[NSImage imageNamed:@"HeaderIconNormal"]];
  [button2 setAlternateImage:[NSImage imageNamed:@"HeaderIconHighlighted"]];
  button2.bordered = NO;
  
  MDSHeaderTableViewController *tableVC = [[MDSHeaderTableViewController alloc] init];
  MDSThumbnailView *thumbnail = [[MDSThumbnailView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  
  [RACObserve(self.centerVC, currentOpenFile) subscribeNext:^(id x) {
    FITSFile *file = x;
    thumbnail.image = [file HDUAtIndex:0].image.image;
    tableVC.openFile = x;
  }];
  
  MDSRightViewController *rightHeaderVC = [[MDSRightViewController alloc] initWithNibName:@"MDSRightViewController" bundle:[NSBundle mainBundle]];
  [rightHeaderVC addSectionWithViewController:tableVC title:@"Headers" preferredHeight:200 setupBlock:nil];
  
  MDSRightViewController *rightThumbnailVC = [[MDSRightViewController alloc] initWithNibName:@"MDSRightViewController" bundle:[NSBundle mainBundle]];
  [rightThumbnailVC addSectionWithView:thumbnail title:@"Thumbnail" preferredHeight:200];
}

#pragma mark - Helpers

- (void)addIcon:(NSButton *)icon withAssociatedRightVC:(MDSRightViewController *)rightVC
{
  [self.iconContainer addIcon:icon];
  [self.rightVCContainer addSubview:rightVC.view];
  
  rightVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  [rightVC.view autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero];
  
  NSValue *iconKey = [NSValue valueWithNonretainedObject:icon];
  
  [self.iconToRightVC setObject:rightVC forKey:iconKey];
  
  icon.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    for (id key in self.iconToRightVC) {
      MDSRightViewController *vc = self.iconToRightVC[key];
      vc.view.hidden = YES;
    }
    rightVC.view.hidden = NO;
    return [RACSignal empty];
  }];
}

#pragma mark - MDSMenuControllerDelegate

- (void)didOpenFileWithURL:(NSURL *)url
{
  [self.centerVC openFileWithURL:url];
}

@end
