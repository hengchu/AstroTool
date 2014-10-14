//
//  MDSHeaderTableView.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/14/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSHeaderTableRowView.h"

@interface MDSHeaderTableRowView() {
  BOOL _hasUpdatedConstraints;
}

@property (nonatomic, strong) NSTextField *keyField;
@property (nonatomic, strong) NSTextField *valueField;
/**
 *  This one is normally not shown.
 */
@property (nonatomic, strong) NSTextField *commentField;

@end

@implementation MDSHeaderTableRowView

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder
{
  if (self = [super initWithCoder:coder]) {
    [self _commonInit];
  }
  return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
  if (self = [super initWithFrame:frameRect]) {
    [self _commonInit];
  }
  return self;
}

- (void)_commonInit
{
  self.keyField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  self.keyField.translatesAutoresizingMaskIntoConstraints = NO;
  self.keyField.font = [NSFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
  self.keyField.bordered = NO;
  self.keyField.backgroundColor = [NSColor clearColor];
  self.keyField.editable = NO;
  self.keyField.lineBreakMode = NSLineBreakByWordWrapping;
  [self addSubview:self.keyField];
  
  self.valueField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
  self.valueField.translatesAutoresizingMaskIntoConstraints = NO;
  self.valueField.font = [NSFont fontWithName:@"Menlo" size:12.0f];
  self.valueField.bordered = NO;
  self.valueField.backgroundColor = [NSColor clearColor];
  self.valueField.editable = NO;
  self.valueField.lineBreakMode = NSLineBreakByWordWrapping;
  [self addSubview:self.valueField];
}

#pragma mark - Layout

- (void)layout
{
  [super layout];
  // Key rect has a max size of 100 x 40
  NSRect keyRect = [self _keyRect];
  // Value rect has a max size of 200 x 40
  NSRect valueRect = [self _valueRect];
  
  CGFloat gapWidth = 20.0f;
  
  valueRect.origin.x = 120.0f;
  valueRect.origin.y = 2.5f;
  valueRect.size.height = ceil(valueRect.size.height)+1;
  valueRect.size.width  = ceil(valueRect.size.width)+1;
  
  keyRect.origin.x = valueRect.origin.x - gapWidth - keyRect.size.width;
  keyRect.origin.y = valueRect.origin.y;
  keyRect.size.height = ceil(keyRect.size.height)+1;
  keyRect.size.width  = ceil(keyRect.size.width)+1;
  
  self.keyField.frame = keyRect;
  self.valueField.frame = valueRect;
  [self.keyField sizeToFit];
  [self.valueField sizeToFit];
}

- (NSSize)intrinsicContentSize
{
  // Key rect has a max size of 100 x 40
  NSRect keyRect = [self _keyRect];
  // Value rect has a max size of 200 x 40
  NSRect valueRect = [self _valueRect];
  
  CGFloat maxHeight = MAX(valueRect.size.height, keyRect.size.height);
  
  // Padding of 2.5 pixels above and below
  return NSMakeSize(400, maxHeight + 2.50 * 2);
}

- (NSRect)_keyRect
{
  return [self.key boundingRectWithSize:NSMakeSize(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.keyField.font}];
}

- (NSRect)_valueRect
{
  return [self.value boundingRectWithSize:NSMakeSize(200, 80) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.keyField.font}];
}

#pragma mark - Setters

- (void)setKey:(NSString *)key
{
  _key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  self.keyField.stringValue = _key;
  [self setNeedsLayout:YES];
}

- (void)setValue:(NSString *)value
{
  _value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  self.valueField.stringValue = _value;
  [self setNeedsLayout:YES];
}

@end
