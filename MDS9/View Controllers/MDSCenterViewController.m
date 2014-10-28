//
//  MDSMainViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSCenterViewController.h"
#import "MDSTheme.h"

@interface MDSCenterViewController () <NSWindowDelegate>

@property (weak) IBOutlet MDSFrameView *frameView;
@property (nonatomic, strong) FITSFile *currentOpenFile;

@end

@implementation MDSCenterViewController

- (void)viewWillAppear
{
  [super viewWillAppear];
  
  [self.frameView.window setDelegate:self];
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
  
  self.frameView.imageView = [[FITSImageView alloc] initWithFITSImage:image];
  
  [self.frameView zoomImageToFit];
}

- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame
{
  [self.frameView zoomImageToFit];
  return YES;
}

@end
