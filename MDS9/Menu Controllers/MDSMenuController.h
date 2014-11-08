//
//  MDSMenuController.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

static NSString * kMDSMenuDidOpenFileNotification = @"kMDSMenuDidOpenFileNotification";
static NSString * kMDSMenuWantHistogramNotification = @"kMDSMenuWantHistogramNotification";

@interface MDSMenuController : NSObject

/**
 *  The @p NSMenu object instantiated from Nib.
 */
@property (strong) IBOutlet NSMenu *menu;

@end
