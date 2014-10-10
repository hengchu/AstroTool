//
//  MDSMainViewController.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDSMenuController.h"

@interface MDSCenterViewController : NSViewController <MDSMenuControllerDelegate>

/**
 *  Delegate call back for @p MDSMenuControllerDelegate.
 *
 *  @param url The url of the file selected.
 */
- (void)didOpenFileWithURL:(NSURL *)url;

@end
