//
//  MDSMenuController.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@protocol MDSMenuControllerDelegate <NSObject>

/**
 *  @p MDSMenuController calls this method when user opens a file.
 *
 *  @param url URL of the file opened.
 */
- (void)didOpenFileWithURL:(NSURL *)url;

@end

@interface MDSMenuController : NSObject

/**
 *  The @p NSMenu object instantiated from Nib.
 */
@property (strong) IBOutlet NSMenu *menu;

/**
 *  Delegate to the menu controller.
 */
@property (nonatomic, weak) id<MDSMenuControllerDelegate> delegate;

@end
