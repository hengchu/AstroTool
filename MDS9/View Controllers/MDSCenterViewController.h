//
//  MDSMainViewController.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDSMenuController.h"
#import "ObjCFITSIO.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MDSCenterViewController : NSViewController

/**
 *  Pointer to the currently @p open file.
 */
@property (nonatomic, readonly) FITSFile *currentOpenFile;

/**
 *  Open a fits file with url
 *
 *  @param url url of the file.
 */
- (void)openFileWithURL:(NSURL *)url;

@end
