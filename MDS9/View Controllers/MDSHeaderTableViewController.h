//
//  MDSHeaderTableViewController.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/16/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjCFITSIO.h"

@interface MDSHeaderTableViewController : NSViewController

@property (nonatomic, strong) FITSFile *openFile;

@end
