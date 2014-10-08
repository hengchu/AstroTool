//
//  MDSMainViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSMainViewController.h"
#import "MDSFrameView.h"

@interface MDSMainViewController ()

@property (weak) IBOutlet NSTextFieldCell *urlLabel;
@property (weak) IBOutlet MDSFrameView *frameView;

@end

@implementation MDSMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
  [self.urlLabel setStringValue:@"Select a file..."];
}

#pragma mark - Menu Controller delegate methods

- (void)didOpenFileWithURL:(NSURL *)url
{
  NSString *fileName = [url lastPathComponent];
  [self.urlLabel setStringValue:fileName];
  
  FITSFile *fitsFile = [FITSFile FITSFileWithURL:url];
  [fitsFile open];
  [fitsFile syncLoadDataOfHDUAtIndex:0];
  
  FITSImage *image = [fitsFile HDUAtIndex:0].image;
  
  self.frameView.imageView = [[FITSImageView alloc] initWithFITSImage:image];
  
  [self.frameView zoomImageToFit];
}

@end
