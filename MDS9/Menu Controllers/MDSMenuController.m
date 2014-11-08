//
//  MDSMenuController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/8/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSMenuController.h"

@implementation MDSMenuController

- (void)awakeFromNib
{
  [super awakeFromNib];
}

- (void)open:(id)sender
{
  NSOpenPanel *panel = [self _openPanel];
  [panel beginWithCompletionHandler:^(NSInteger result) {
    if (result == NSFileHandlingPanelOKButton) {
      [[NSNotificationCenter defaultCenter] postNotificationName:kMDSMenuDidOpenFileNotification
                                                          object:self
                                                        userInfo:@{@"fileURL":panel.URL}];
    }
  }];
}

- (void)wantsHistogram:(id)sender
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kMDSMenuWantHistogramNotification
                                                      object:self];
}

- (NSOpenPanel *)_openPanel
{
  static NSOpenPanel *panel;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories    = NO;
    panel.canChooseFiles          = YES;
    panel.allowsMultipleSelection = NO;
  });
  
  return panel;
}

@end
