//
//  MDSIconContainerView.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/26/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSIconContainerView.h"
#import "MDSTheme.h"
#import <PureLayout/PureLayout.h>

#define H_MARGIN 10.0f

@interface MDSIconContainerView() {
  BOOL _hasUpdatedConstraints;
}

@property (nonatomic, strong) NSMutableArray *icons;
@property (nonatomic, strong) NSView *iconContainer;

@end

@implementation MDSIconContainerView

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder
{
  if (self = [super initWithCoder:coder]) {
    [self _commonInit];
  }
  return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
  if (self = [super initWithFrame:frameRect]) {
    [self _commonInit];
  }
  return self;
}

- (void)_commonInit
{
  self.icons = [NSMutableArray array];
  self.wantsLayer = YES;
  self.layer.backgroundColor = [MDSTheme panelColor].CGColor;
  
  self.iconContainer = [NSView newAutoLayoutView];
  self.iconContainer.wantsLayer = YES;
  self.iconContainer.layer.backgroundColor = [NSColor clearColor].CGColor;
  [self.iconContainer setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh
                                               forOrientation:NSLayoutConstraintOrientationHorizontal];
  [self.iconContainer setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh
                                               forOrientation:NSLayoutConstraintOrientationVertical];
  [self addSubview:self.iconContainer];
}

#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout
{
  return YES;
}

- (void)updateConstraints
{
  if (!_hasUpdatedConstraints) {
    
    for (NSView *icon in self.icons) {
      [icon removeFromSuperview];
      [self.iconContainer addSubview:icon];
    }
    
    for (NSView *icon in self.icons) {
      
      NSUInteger idx = [self.icons indexOfObject:icon];
      
      if (self.icons.count > 2) {
        
        if (idx == 0) {
          [icon autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeRight];
        } else if (idx == self.icons.count-1) {
          [icon autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeLeft];
        } else {
          NSView *pView = self.icons[idx-1];
          NSView *nView = self.icons[idx+1];
          
          [icon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
          [icon autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
          [icon autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pView withOffset:H_MARGIN];
          [icon autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:nView withOffset:-H_MARGIN];
        }
        
      } else if (self.icons.count == 1) {
        
        [icon autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero];
        
      } else { // self.icons.count == 2
        
        NSAssert(self.icons.count == 2, @"Impossible number of icons!");
        
        if (idx == 0) {
          [icon autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeRight];
          NSView *nIcon = self.icons[idx+1];
          [icon autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:nIcon withOffset:-H_MARGIN];
        } else {
          [icon autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsZero excludingEdge:ALEdgeLeft];
        }
        
      }
      
    }
    
    [self.iconContainer removeFromSuperview];
    
    [self addSubview:self.iconContainer];
    
    [self.iconContainer autoCenterInSuperview];
    
    [self.iconContainer layoutSubtreeIfNeeded];
    
    _hasUpdatedConstraints = YES;
  }
  [super updateConstraints];
}

- (void)setNeedsUpdateConstraints:(BOOL)needsUpdateConstraints
{
  _hasUpdatedConstraints = NO;
  [super setNeedsUpdateConstraints:needsUpdateConstraints];
}

#pragma mark - Public API

- (void)addIcon:(NSView *)icon
{
  icon.translatesAutoresizingMaskIntoConstraints = NO;
  [self.icons addObject:icon];
  [self setNeedsUpdateConstraints:YES];
}

@end