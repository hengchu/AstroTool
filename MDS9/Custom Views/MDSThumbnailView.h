//
//  MDSThumnailView.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/26/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MDSThumbnailView : NSView

@property (nonatomic, strong) NSImage *image;
@property (nonatomic) NSRect currentFocusRect;

@end
