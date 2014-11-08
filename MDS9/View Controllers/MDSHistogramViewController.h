//
//  MDSHistogramViewController.h
//  MDS9
//
//  Created by Hengchu Zhang on 11/7/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MDSHistogramViewController : NSViewController

- (void)setDataToPlot:(double *)data count:(NSUInteger)count;

- (void)plotHistogram;

@end
