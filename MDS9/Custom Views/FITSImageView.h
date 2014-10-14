//
//  FITSImageView.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjCFITSIO.h"

@interface FITSImageView : NSImageView

@property (nonatomic, strong) FITSImage *fitsImage;

- (instancetype)initWithFITSImage:(FITSImage *)image;

@end
