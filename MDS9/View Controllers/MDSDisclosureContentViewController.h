//
//  MDSDisclosureContentViewController.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/16/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MDSDisclosureContentViewController : NSViewController

@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSView *disclosedView;

- (void)toggleDisclosure:(id)sender;

@end
