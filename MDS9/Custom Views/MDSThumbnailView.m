//
//  MDSThumnailView.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/26/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSThumbnailView.h"
#import <PureLayout/PureLayout.h>

@interface MDSThumbnailView() {

}

@property (nonatomic, strong) NSImageView* imageView;

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
  
  CGFloat HWRatio = self.bounds.size.height / self.bounds.size.width;
  CGRect frame;
  
  [self addSubview:self.imageView];
  
  if (HWRatio > 1) {
    frame.size.height = self.bounds.size.height;
    frame.size.width = frame.size.height / HWRatio;
    
    frame.origin.y = 0;
    frame.origin.x = self.bounds.size.width / 2 - frame.size.width / 2;
  } else {
    frame.size.width = self.bounds.size.width;
    frame.size.height = frame.size.width * HWRatio;
    
    frame.origin.x = 0;
    frame.origin.y = self.bounds.size.height / 2 - frame.size.height / 2;
  }
  
  self.imageView.frame = frame;
  
  [super layout];
}

@end