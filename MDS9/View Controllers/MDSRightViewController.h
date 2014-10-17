//
//  MDSRightViewController.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/10/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDSCenterViewController.h"

@interface MDSRightViewController : NSViewController

@property (nonatomic, weak) MDSCenterViewController *centerVC;

/**
 *  Use this method to add a section to the right view controller. It keeps a reference to the view
 *  controller added to it.
 *
 *  @param vc              The view controller whose view is to be added to the right view controller.
 *  @param title           The title displayed at this section.
 *  @param preferredHeight The preferred height of the view of the view controller to be added.
 *  @param vcSetupBlock    If the view controller needs any additional setup after it's added, do it here.
 */
- (void)addSectionWithViewController:(NSViewController *)vc
                               title:(NSString *)title
                     preferredHeight:(CGFloat)height
                          setupBlock:(void(^)(NSViewController *vc))vcSetupBlock;


/**
 *  Use this method to add a section to the right view controller
 *
 *  @param view         The view to be added to the right section.
 *  @param title        The title displayed at this section.
 *  @param height       preferred height of the view.
 */
- (void)addSectionWithView:(NSView *)view
                     title:(NSString *)title
           preferredHeight:(CGFloat)height;

@end
