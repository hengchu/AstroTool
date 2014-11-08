//
//  MDSAbstractHistogram.h
//  MDS9
//
//  Created by Hengchu Zhang on 11/2/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface MDSAbstractHistogram : NSObject <CPTBarPlotDataSource>

/**
 *  Initializes an @p MDSAbstractHistogram object
 *
 *  @param values values to be plotted on a histogram, the
 *                abstract histogram object would hold a copy
 *                of this array.
 *
 *  @return an initialized instance of the MDSAbstractHistogram object.
 */
- (instancetype)initWithCArray:(double *)values size:(NSUInteger)count;

@property (nonatomic, readonly) double    binSize;
@property (nonatomic, readonly) NSInteger binCount;

/**
 *  Returns the bin height for a given index
 *
 *  @param idx index of the bin, must be smaller than @p binCount.
 *
 *  @return height for the bin with given @p idx.
 */
- (double)valueForBinIndex:(NSUInteger)idx;

@property (nonatomic, readonly) double xMax;
@property (nonatomic, readonly) double xMin;
@property (nonatomic, readonly) double yMax;
@property (nonatomic, readonly) double yMin;
@property (nonatomic, readonly) double barWidth;

@end
