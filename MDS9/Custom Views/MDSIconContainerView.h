//
//  MDSIconContainerView.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/26/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MDSIconContainerView : NSView

/**
 *  Add an icon to the container
 *
 *  @param icon The icon to be added, it will be resized to a square that fits in
 *              the container.
 */
- (void)addIcon:(NSView *)icon;

@end
