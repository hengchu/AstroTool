//
//  MDSThumnailView.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/26/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSThumbnailView.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MDSThumbnailView() {

}

@property (nonatomic, strong) NSImageView* imageView;
@property (nonatomic, strong) NSView *focusRect;

@end

@implementation MDSThumbnailView

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
  self.imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  self.imageView.imageScaling = NSImageScaleProportionallyDown;
  [self addSubview:self.imageView];
  
  self.focusRect = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  self.focusRect.wantsLayer = YES;
  self.focusRect.layer.borderColor = [NSColor greenColor].CGColor;
  self.focusRect.layer.borderWidth = 1.0f;
  [self addSubview:self.focusRect];
  
  [RACObserve(self, currentFocusRect) subscribeNext:^(id x) {
    
    NSRect visibleRect = [x rectValue];
    
    if (!NSIsEmptyRect(visibleRect)) {
      NSRect imageViewFrame = self.imageView.frame;
      NSRect focusRectFrame;
      
      focusRectFrame.origin.x = visibleRect.origin.x / self.image.size.width * imageViewFrame.size.width;
      focusRectFrame.origin.y = visibleRect.origin.y / self.image.size.height * imageViewFrame.size.height;
      focusRectFrame.size.height = visibleRect.size.height / self.image.size.height * imageViewFrame.size.height;
      focusRectFrame.size.width  = visibleRect.size.width / self.image.size.width * imageViewFrame.size.width;

      focusRectFrame = [self convertRect:focusRectFrame fromView:self.imageView];
      
      self.focusRect.frame = focusRectFrame;
    }
    
  }];
}

#pragma mark - Setter

- (void)setImage:(NSImage *)image
{
  if (image != _image) {
    _image = image;
    self.imageView.image = image;
    [self setNeedsLayout:YES];
  }
}

#pragma mark - Layout

- (void)layout
{
  [super layout];

  CGSize selfSize = self.bounds.size;
  CGSize imageSize = (self.image) ? self.image.size : CGSizeMake(100, 100);
  
  CGRect imageViewFrame;
  
  if (imageSize.width > imageSize.height) {
    imageViewFrame.size.width = selfSize.width;
    imageViewFrame.size.height = imageSize.height / imageSize.width * imageViewFrame.size.width;
  } else {
    imageViewFrame.size.height = selfSize.height;
    imageViewFrame.size.width = imageSize.width / imageSize.height * imageViewFrame.size.height;
  }
  
  imageViewFrame.origin.x = (selfSize.width - imageViewFrame.size.width) / 2;
  imageViewFrame.origin.y = (selfSize.height - imageViewFrame.size.height) / 2;
  
  self.imageView.frame = imageViewFrame;

  [super layout];
}

@end