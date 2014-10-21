//
//  MDSFrameView.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSFrameView.h"
#import "MDSTheme.h"
#import "MDSCenteredClipView.h"
#import <PureLayout/PureLayout.h>

@interface MDSFrameView() {
  BOOL _hasUpdatedConstraints;
}

@property (nonatomic, strong) NSScrollView *scrollView;

@end

@implementation MDSFrameView

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
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
  _hasUpdatedConstraints = NO;
  
  self.scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:self.scrollView];
  
  [self.scrollView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
  [self.scrollView setBorderType:NSNoBorder];
  
  [self.scrollView setHasHorizontalScroller:YES];
  [self.scrollView setHasVerticalScroller:YES];
  [self.scrollView setAutohidesScrollers:YES];
  
  self.scrollView.allowsMagnification = YES;
  self.scrollView.minMagnification = 0.0001;
  self.scrollView.maxMagnification = 1000;
  
  self.scrollView.backgroundColor = [MDSTheme panelColor];
  
  MDSCenteredClipView *clipView = [[MDSCenteredClipView alloc] initWithFrame:self.scrollView.bounds];
  clipView.centersDocumentView = YES;
  [self.scrollView setContentView:clipView];
}

#pragma mark - Constraints;

- (BOOL)needsUpdateConstraints
{
  if (!_hasUpdatedConstraints) return YES;
  return [super needsUpdateConstraints];
}

- (void)updateConstraints
{
  if (!_hasUpdatedConstraints) {
    [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsMake(0, 0, 0, 0)];
    _hasUpdatedConstraints = YES;
  }
  [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout
{
  return YES;
}

#pragma mark - Live resize

- (void)viewDidEndLiveResize
{
  [super viewDidEndLiveResize];
  [self zoomImageToFit];
}

#pragma mark - Setters

- (void)setImageView:(FITSImageView *)imageView
{
  if (_imageView != imageView) {
    
    _imageView = imageView;
    [self.scrollView setDocumentView:imageView];
  }
}

#pragma mark - Public API

- (void)zoomImageToFit
{
  NSSize size = self.imageView.image.size;
  NSSize selfSize = self.bounds.size;
  
  CGFloat xScale = selfSize.width / size.width;
  CGFloat yScale = selfSize.height / size.height;
  
  [self zoomToScale:MIN(xScale, yScale)];
  
}

- (void)zoomToScale:(CGFloat)scale
{
  self.scrollView.magnification = scale;
}

@end
