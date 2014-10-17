//
//  MDSStackHeaderView.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/14/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MDSDisclosureView : NSView


/**
 *  The header text on the left.
 */
@property (nonatomic, strong) NSString *headerText;

/**
 *  String that would be shown in the button on the right side.
 */
@property (nonatomic, strong) NSString *hideButtonText;

/**
 *  The block that runs when the button is clicked.
 */
@property (nonatomic, strong) void (^hideButtonClickReponse)(void);

@end
