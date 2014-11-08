//
//  MDSHistogramViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 11/7/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSHistogramViewController.h"
#import "MDSAbstractHistogram.h"

@interface MDSHistogramViewController ()

@property (nonatomic, strong) MDSAbstractHistogram *abstractHistogram;
@property (weak) IBOutlet CPTGraphHostingView *graphHostingView;

@property (nonatomic, strong) CPTGraph *graph;

@end

@implementation MDSHistogramViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do view setup here.
  
  [self.graphHostingView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  
  self.graph = [[CPTXYGraph alloc] initWithFrame:self.graphHostingView.bounds
                                      xScaleType:CPTScaleTypeLinear
                                      yScaleType:CPTScaleTypeLog];
  self.graph.plotAreaFrame.masksToBorder = NO;
  
  self.graphHostingView.hostedGraph = self.graph;
  [self.graph applyTheme:[CPTTheme themeNamed:kCPTSlateTheme]];
  
  
}

- (void)plotHistogram
{
  double xMin = self.abstractHistogram.xMin;
  double xMax = self.abstractHistogram.xMax;
  double yMin = 0.0f;
  double yMax = self.abstractHistogram.yMax;
  
  CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
  plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xMin)
                                                  length:CPTDecimalFromDouble(xMax-xMin)];
  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yMin)
                                                  length:CPTDecimalFromDouble(yMax)];
  
  self.graph.paddingBottom = 30.0f;
  self.graph.paddingLeft   = 60.0f;
  self.graph.paddingTop    = 20.0f;
  self.graph.paddingRight  = 20.0f;
  
  CPTXYAxis *y = [(CPTXYAxisSet *)self.graph.axisSet yAxis];
  y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
  CPTXYAxis *x = [(CPTXYAxisSet *)self.graph.axisSet xAxis];
  x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
  
  CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor]
                                             horizontalBars:NO];
  barPlot.identifier = @"IntensityHistogram";
  
  CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
  barLineStyle.lineColor = [CPTColor whiteColor];
  barLineStyle.lineWidth = 0.5;
  
  barPlot.lineStyle = barLineStyle;
  
  barPlot.dataSource = self.abstractHistogram;
  barPlot.barWidth   = CPTDecimalFromDouble(self.abstractHistogram.barWidth);
  barPlot.barOffset  = CPTDecimalFromDouble(self.abstractHistogram.barWidth/2);
  
  [self.graph addPlot:barPlot toPlotSpace:self.graph.defaultPlotSpace];
  [barPlot dataNeedsReloading];
}

- (void)setDataToPlot:(double *)data count:(NSUInteger)count
{
  self.abstractHistogram = [[MDSAbstractHistogram alloc] initWithCArray:data size:count];
}

@end
