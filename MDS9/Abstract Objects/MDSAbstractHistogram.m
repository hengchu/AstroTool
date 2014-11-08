//
//  MDSAbstractHistogram.m
//  MDS9
//
//  Created by Hengchu Zhang on 11/2/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSAbstractHistogram.h"
#import "MDSTransformationFunctions.h"
#import <Accelerate/Accelerate.h>

#define MAX_BIN_COUNT 300

int cmpfunc(const void * a, const void * b)
{
  if (*(double *)a > *(double *)b) return 1;
  else if (*(double *)a == *(double *)b) return 0;
  return -1;
}


@interface MDSAbstractHistogram() {
  double     *_data;
  NSUInteger  _count;
  double      _IQR; // interquantile range
  double     *_binValues;
  NSUInteger  _maxBinCount;
}

@property (nonatomic) double    binSize;
@property (nonatomic) NSInteger binCount;

@end

@implementation MDSAbstractHistogram

#pragma mark - Initializer

- (instancetype)initWithCArray:(double *)values size:(NSUInteger)count
{
  if (self = [super init]) {
    _count = count;
    _data = malloc(sizeof(double) * count);
    memcpy(_data, values, _count * sizeof(double));
    qsort(_data, _count, sizeof(double), cmpfunc);
    [self configureOptimalBinSize];
  }
  return self;
}

- (void)configureOptimalBinSize
{
  NSInteger Q1 = _count / 4;
  NSInteger Q3 = _count * 3 / 4;
  
  _IQR = _data[Q3] - _data[Q1];
  
  self.binSize  = 2 * _IQR * pow(_count, -1.0/3);
  self.binCount = ceil((_data[_count - 1] - _data[0]) / self.binSize);
  
  _binValues = calloc(sizeof(double), self.binCount);
  
  double min = _data[0];
  min *= -1.0;
  double *tempdata = malloc(sizeof(double) * _count);
  vDSP_vsaddD(_data, 1, &min, tempdata, 1, _count);

  dispatch_apply(_count, dispatch_get_global_queue(0, 0), ^(size_t i) {
    double value     = tempdata[i];
    double remainder = fmod(tempdata[i], self.binSize);
    int    multiple  = (value-remainder) / self.binSize;
    _binValues[multiple] += 1.0;
  });
  
  int bincount = (int)self.binCount;
  double one = 1;
  
  vDSP_vsaddD(_binValues, 1, &one, _binValues, 1, bincount);
  
  vvlog10(_binValues, _binValues, &bincount);
  
  free(tempdata);
  
  for (NSUInteger i = 0; i < self.binCount; i++) {
    if (_binValues[i] > _maxBinCount) {
      _maxBinCount = _binValues[i];
    }
  }
}

- (double)valueForBinIndex:(NSUInteger)idx
{
  NSAssert(idx < self.binCount, @"Bin index out of range!");
  return _binValues[idx];
}

- (void)dealloc
{
  free(_data);
  free(_binValues);
}

#pragma mark - Getters

- (double)xMax
{
  return _data[_count-1];
}

- (double)xMin
{
  return _data[0];
}

- (double)yMax
{
  return _maxBinCount;
}

- (double)yMin
{
  return 0;
}

- (double)barWidth
{
  double max = _data[_count - 1];
  double min = _data[0];
  
  double width = (max-min) / self.binCount;

  return width;
}

#pragma mark - CPTBarPlotDataSource

- (CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx
{
  return [CPTFill fillWithColor:[[CPTColor blackColor] colorWithAlphaComponent:0.75]];
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
  return self.binCount;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
  double width = self.barWidth;
  
  if (fieldEnum == CPTBarPlotFieldBarLocation) {
    return @(width * idx + _data[0]);
  } else if (fieldEnum == CPTBarPlotFieldBarTip) {
    return @([self valueForBinIndex:idx]);
  }
  
  return @(0.0f);
}

@end
