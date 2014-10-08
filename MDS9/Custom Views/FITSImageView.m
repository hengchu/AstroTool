//
//  FITSImageView.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "FITSImageView.h"

@implementation FITSImageView

- (instancetype)initWithFITSImage:(FITSImage *)image
{
  NSImage *fitsImage = image.image;
  if (self = [super initWithFrame:NSMakeRect(0, 0, fitsImage.size.width, fitsImage.size.height)])
  {
    _fitsImage = image;
    self.image = fitsImage;
  }
  return self;
}

@end
