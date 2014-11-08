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
#import "MDSScalingViewController.h"
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
  
  [self createIconContainer];
  [self createRightVCContainer];
  [self createCenterVC];
  [self createSeparators];
  [self createInterViewConstraints];
  self.iconToRightVC = [NSMutableDictionary dictionary];
  
  NSButton *headerIcon = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  [headerIcon setImage:[NSImage imageNamed:@"HeaderIconNormal"]];
  [headerIcon setAlternateImage:[NSImage imageNamed:@"HeaderIconHighlighted"]];
  [headerIcon setButtonType:NSMomentaryChangeButton];
  headerIcon.bordered = NO;
  
  NSButton *focusIcon = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  [focusIcon setImage:[NSImage imageNamed:@"FocusIconNormal"]];
  [focusIcon setAlternateImage:[NSImage imageNamed:@"FocusIconHighlighted"]];
  [focusIcon setButtonType:NSMomentaryChangeButton];
  focusIcon.bordered = NO;
    
  MDSHeaderTableViewController *tableVC = [[MDSHeaderTableViewController alloc] init];
  MDSThumbnailView *thumbnail = [[MDSThumbnailView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  
  [RACObserve(self.centerVC, currentOpenFile) subscribeNext:^(id x) {
    FITSFile *file = x;
    thumbnail.image = [file HDUAtIndex:0].image.image;
    tableVC.openFile = x;
  }];
  
  [RACObserve(self.centerVC.frameView, currentVisibleRect) subscribeNext:^(id x) {
    NSRect rect = [x rectValue];
    thumbnail.currentFocusRect = rect;
  }];
  
  MDSRightViewController *rightHeaderVC = [[MDSRightViewController alloc] initWithNibName:@"MDSRightViewController"
                                                                                   bundle:[NSBundle mainBundle]];
  [rightHeaderVC addSectionWithViewController:tableVC
                                        title:@"Headers"
                              preferredHeight:400
                                   setupBlock:nil];
  
  MDSRightViewController *rightThumbnailVC = [[MDSRightViewController alloc] initWithNibName:@"MDSRightViewController"
                                                                                      bundle:[NSBundle mainBundle]];
  MDSScalingViewController *scalingVC = [[MDSScalingViewController alloc] initWithNibName:@"MDSScalingViewController"
                                                                                   bundle:[NSBundle mainBundle]];
  
  [[RACSignal combineLatest:@[RACObserve(scalingVC, bias),
                              RACObserve(scalingVC, contrast),
                              RACObserve(scalingVC, scaleType)]
                    reduce:^(NSNumber *bias, NSNumber *contrast, NSNumber *scaleType)
  {
    return RACTuplePack(bias, contrast, scaleType);
  }] subscribeNext:^(id x) {
    RACTupleUnpack(NSNumber *bias, NSNumber *contrast, NSNumber *scaleType) = x;
    if (self.centerVC.frameView.imageView.fitsImage) {
      FITSImage *image = self.centerVC.frameView.imageView.fitsImage;
      MDSScaleType scale = [scaleType unsignedIntegerValue];
      switch (scale) {
        case MDSLinearScale:
          [image applyLinearScaleWithBias:bias.doubleValue contrast:contrast.doubleValue];
          break;
        case MDSLogScale:
          [image applyLogScaleWithBias:bias.doubleValue contrast:contrast.doubleValue exponent:1000.0];
          break;
        case MDSAsinhScale:
          [image applyAsinhScaleWithBias:bias.doubleValue contrast:contrast.doubleValue];
          break;
        case MDSPowerScale:
          [image applyPowerScaleWithBias:bias.doubleValue contrast:contrast.doubleValue exponent:1000.0];
          break;
        case MDSSqrtScale:
          [image applySqrtScaleWithBias:bias.doubleValue contrast:contrast.doubleValue];
          break;
        case MDSSquaredScale:
          [image applySquaredScaleWithBias:bias.doubleValue contrast:contrast.doubleValue];
          break;
        case MDSZScale:
          [image setImageData:image.rawIntensity];
          break;
        default:
          break;
      }
    }
  }];
  
  [rightThumbnailVC addSectionWithView:thumbnail
                                 title:@"Thumbnail"
                       preferredHeight:200];
  [rightThumbnailVC addSectionWithViewController:scalingVC
                                           title:@"Scale"
                                 preferredHeight:150
                                      setupBlock:nil];
  
  [self addIcon:headerIcon withAssociatedRightVC:rightHeaderVC];
  [self addIcon:focusIcon withAssociatedRightVC:rightThumbnailVC];
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
  icon.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSButton *input) {
    for (NSValue *key in self.iconToRightVC) {
      NSButton *keyButton = [key nonretainedObjectValue];
      keyButton.highlighted = NO;
      MDSRightViewController *vc = self.iconToRightVC[key];
      vc.view.hidden = YES;
    }
    rightVC.view.hidden = NO;
    // Let stack unwind first, so we're out of mouseDown.
    [self performSelector:@selector(highLightButton:) withObject:input afterDelay:0.0f];
    return [RACSignal empty];
  }];
  
  rightVC.view.hidden = YES;
}

- (void)highLightButton:(NSButton *)button
{
  button.highlighted = YES;
}

@end
