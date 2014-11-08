//
//  MDSMainViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSCenterViewController.h"
#import "MDSTheme.h"
#import "MDSMenuController.h"
#import "MDSHistogramViewController.h"

@interface MDSCenterViewController () <NSWindowDelegate>

@property (weak) IBOutlet MDSFrameView *frameView;
@property (nonatomic, strong) FITSFile *currentOpenFile;
@property (nonatomic, strong) NSWindow *histogramWindow;

@end

@implementation MDSCenterViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receivedOpenFileNotification:)
                                               name:kMDSMenuDidOpenFileNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receivedWantsHistogramNotification:)
                                               name:kMDSMenuWantHistogramNotification
                                             object:nil];
  
  self.histogramWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 600, 400)
                                                     styleMask:NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask
                                                       backing:NSBackingStoreBuffered
                                                         defer:NO];
  [self.histogramWindow setReleasedWhenClosed:NO];

}

- (void)viewWillAppear
{
  [super viewWillAppear];
  
  [self.frameView.window setDelegate:self];
}

#pragma mark - Notification center

- (void)receivedOpenFileNotification:(NSNotification *)notification
{
  NSURL *url = [notification.userInfo objectForKey:@"fileURL"];
  [self openFileWithURL:url];
}

- (void)receivedWantsHistogramNotification:(NSNotification *)notification
{
  // Brings up histogram.
  [self.histogramWindow cascadeTopLeftFromPoint:NSMakePoint(300, 300)];
  [self.histogramWindow makeKeyAndOrderFront:self];
  
  self.histogramWindow.title        = @"Histogram";
  self.histogramWindow.delegate     = self;
  self.histogramWindow.parentWindow = [self.view window];
  
  MDSHistogramViewController *histoVC = [[MDSHistogramViewController alloc] initWithNibName:@"MDSHistogramViewController" bundle:[NSBundle mainBundle]];
  self.histogramWindow.contentViewController = histoVC;
  
  NSUInteger count = self.frameView.imageView.fitsImage.size.nx
                   * self.frameView.imageView.fitsImage.size.ny;
  [histoVC setDataToPlot:self.frameView.imageView.fitsImage.rawIntensity count:count];

  [histoVC plotHistogram];
}

#pragma mark - Setters

- (void)setCurrentOpenFile:(FITSFile *)currentOpenFile
{
  if (_currentOpenFile) {
    [_currentOpenFile close];
  }
  _currentOpenFile = currentOpenFile;
}

#pragma mark - Public API

- (void)openFileWithURL:(NSURL *)url
{
  FITSFile *fitsFile = [FITSFile FITSFileWithURL:url];
  
  [fitsFile open];
  
  [fitsFile syncLoadDataOfHDUAtIndex:0];
  
  self.currentOpenFile = fitsFile;
  
  FITSImage *image = [fitsFile HDUAtIndex:0].image;
  
  NSAssert(image != nil, @"File doesn't contain an image");
  
  self.frameView.imageView = [[FITSImageView alloc] initWithFITSImage:image];

  [self.frameView zoomImageToFit];
}

- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame
{
  if (window == self.view.window) {
    [self.frameView zoomImageToFit];
  }
  return YES;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
