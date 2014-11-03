//
//  MDSScalingViewController.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/30/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, MDSScaleType) {
  MDSLinearScale,
  MDSLogScale,
  MDSPowerScale,
  MDSAsinhScale,
  MDSSqrtScale,
  MDSSquaredScale,
  MDSZScale
};

@interface MDSScalingViewController : NSViewController

@property (nonatomic, readonly) CGFloat bias;
@property (nonatomic, readonly) CGFloat contrast;
@property (nonatomic, readonly) MDSScaleType scaleType;

@end
