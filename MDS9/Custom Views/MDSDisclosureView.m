//
//  MDSStackHeaderView.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/14/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSDisclosureView.h"
#import "MDSTheme.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MDSDisclosureView() {
  BOOL _hasUpdatedConstraints;
}

@property (nonatomic, strong) NSTextField *headerField;
@property (nonatomic, strong) NSTextField *buttonField;
@property (nonatomic, strong) NSTrackingArea *buttonTrackingArea;

@end

@implementation MDSDisclosureView

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
  self.headerField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 10, 10)];
  self.headerField.translatesAutoresizingMaskIntoConstraints = NO;
  [self.headerField.cell setUsesSingleLineMode:YES];
  self.headerField.font            = [NSFont boldSystemFontOfSize:12.0];
  self.headerField.bordered        = NO;
  self.headerField.editable        = NO;
  self.headerField.backgroundColor = [NSColor clearColor];
  [self addSubview:self.headerField];
  
  self.buttonField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 10, 10)];
  self.buttonField.translatesAutoresizingMaskIntoConstraints = NO;
  [self.buttonField.cell setUsesSingleLineMode:YES];
  self.buttonField.font      = [NSFont boldSystemFontOfSize:12.0];
  self.buttonField.textColor = [MDSTheme stackHeaderButtonTextColor];
  self.buttonField.bordered  = NO;
  self.buttonField.editable  = NO;
  self.buttonField.backgroundColor = [NSColor clearColor];
  self.buttonField.hidden = YES;
  [self addSubview:self.buttonField];

  _hasUpdatedConstraints = NO;
  
  [RACObserve(self.buttonField, frame) subscribeNext:^(id x) {
    NSValue *frameValue = x;
    self.buttonTrackingArea = [[NSTrackingArea alloc] initWithRect:frameValue.rectValue
                                                           options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp
                                                             owner:self
                                                          userInfo:nil];
    [self addTrackingArea:self.buttonTrackingArea];
  }];
}

#pragma makr - Responder

- (void)mouseEntered:(NSEvent *)theEvent
{
  self.buttonField.hidden = NO;
  [super mouseExited:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent
{
  self.buttonField.hidden = YES;
  [super mouseExited:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent
{
  NSPoint clickPointInWindow = theEvent.locationInWindow;
  NSPoint convertedPoint = [self convertPoint:clickPointInWindow fromView:nil];
  if (NSPointInRect(convertedPoint, self.buttonField.frame)) {
    if (self.hideButtonClickReponse) {
      self.hideButtonClickReponse();
    }
  }
}

#pragma mark - Setters

- (void)setHeaderText:(NSString *)headerText
{
  _headerText = headerText;
  self.headerField.stringValue = headerText;
  [self setNeedsUpdateConstraints:YES];
}

- (void)setHideButtonText:(NSString *)hideButtonText
{
  _hideButtonText = hideButtonText;
  self.buttonField.stringValue = hideButtonText;
  [self setNeedsUpdateConstraints:YES];
}

#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout
{
  return YES;
}

- (void)setNeedsUpdateConstraints:(BOOL)needsUpdateConstraints
{
  _hasUpdatedConstraints = needsUpdateConstraints && _hasUpdatedConstraints;
  [super setNeedsUpdateConstraints:needsUpdateConstraints];
}

- (void)updateConstraints
{
  if (!_hasUpdatedConstraints) {
    
    [self.headerField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.headerField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    
    [self.buttonField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.buttonField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    
    [self.headerField sizeToFit];
    [self.buttonField sizeToFit];
    
    _hasUpdatedConstraints = YES;
  }
  [super updateConstraints];
}

@end