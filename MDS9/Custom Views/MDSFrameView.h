//
//  MDSFrameView.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FITSImageView.h"

@interface MDSFrameView : NSView

@property (nonatomic, strong) FITSImageView *imageView;

/**
 *  Zooms the hosted image to fit.
 */
- (void)zoomImageToFit;

/**
 *  Zooms the hosted image to specified @p scale.
 *
 *  @param scale between 0.1 and 2.
 */
- (void)zoomToScale:(CGFloat)scale;

@end
