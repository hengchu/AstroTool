//
//  MDSRightViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/10/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSRightViewController.h"
#import "NSArray+Map.h"
#import "MDSHeaderTableRowView.h"
#import <PureLayout/PureLayout.h>

@interface MDSRightViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSStackView *stackView;
@property (nonatomic, weak) IBOutlet NSTableView *headerView;
@property (nonatomic, strong) NSArray *headers;

@end

@implementation MDSRightViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do view setup here.
  
  self.headerView.dataSource = self;
  self.headerView.delegate = self;
  [self.headerView setHeaderView:nil];
}

- (void)viewWillAppear
{
  [super viewWillAppear];
  [[[RACObserve(self.centerVC, currentOpenFile)
    skip:1]
   map:^id(id value) {
     FITSFile *file = value;
     [file syncLoadHeaderOfMainHDU];
     return [[[[file mainHDU] header] lines] mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
       FITSHeaderLine *line = obj;
       return RACTuplePack(line.key, line.value, line.comment);
     }];
   }] subscribeNext:^(id x) {
     self.headers = x;
     [self.headerView reloadData];
     [self.headerView sizeLastColumnToFit];
   }];
}

#pragma mark - Table view datasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  NSLog(@"%ld", self.headers.count);
  return self.headers.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
  RACTupleUnpack(NSString *key, NSString *value, NSString *comment) = self.headers[row];
  
  MDSHeaderTableRowView *view = [[MDSHeaderTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  
  view.key = key;
  view.value = value;
  view.comment = comment;
  
  NSSize size = view.intrinsicContentSize;
  
  return size.height;
}

#pragma mark - Table view delegate

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
  RACTupleUnpack(NSString *key, NSString *value, NSString *comment) = self.headers[row];
  
  MDSHeaderTableRowView *view = [[MDSHeaderTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  
  NSLog(@"%@ : %@", key, value);
  
  view.key = key;
  view.value = value;
  view.comment = comment;
  view.wantsLayer = YES;
  view.layer.backgroundColor = [NSColor clearColor].CGColor;
  
  NSSize size = view.intrinsicContentSize;
  view.frame = NSMakeRect(0, 0, size.width, size.height);
  
  return view;
}

@end
