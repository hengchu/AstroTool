//
//  MDSHeaderTableView.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/14/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MDSHeaderTableRowView : NSView

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *comment;

@end
