//
//  MDSDisclosureContentViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/16/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSDisclosureContentViewController.h"
#import "MDSDisclosureView.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/RACEXTScope.h>

@import QuartzCore;

@interface MDSDisclosureContentViewController ()

@property (weak) IBOutlet MDSDisclosureView *headerView;

@property (strong) NSLayoutConstraint *closingConstraint;

@end

@implementation MDSDisclosureContentViewController
{
  BOOL _disclosureIsClosed;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
  self.headerView.headerText = @"Header";
  self.headerView.hideButtonText = @"Hide";
  
  self.headerView.hideButtonClickReponse = ^{
    [self toggleDisclosure:self];
  };
  
  self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.headerView];
}

- (void)setDisclosedView:(NSView *)disclosedView
{
  if (_disclosedView != disclosedView)
  {
    [self.disclosedView removeFromSuperview];
    
    _disclosedView = disclosedView;
    _disclosedView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_disclosedView];
    
    [_disclosedView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_disclosedView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_disclosedView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headerView];
    [ALView autoSetPriority:600 forConstraints:^{
      [_disclosedView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }];
    
    /* These are the visual format that Apple official example gives
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_disclosedView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_disclosedView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView][_disclosedView]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_headerView, _disclosedView)]];
    
    // add an optional constraint (but with a priority stronger than a drag), that the disclosing view
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_disclosedView]-(0@600)-|"
                                                                      options:0 metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_disclosedView)]];
     */
  }
}

- (void)toggleDisclosure:(id)sender
{
  NSLog(@"Disclosing!");
  if (!_disclosureIsClosed)
  {
    CGFloat distanceFromHeaderToBottom = NSMinY(self.view.bounds) - NSMinY(self.headerView.frame);
    
    if (!self.closingConstraint)
    {
      // The closing constraint is going to tie the bottom of the header view to the bottom of the overall disclosure view.
      // Initially, it will be offset by the current distance, but we'll be animating it to 0.
      self.closingConstraint = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:distanceFromHeaderToBottom];
    }
    self.closingConstraint.constant = distanceFromHeaderToBottom;
    [self.view addConstraint:self.closingConstraint];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
      context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
      // Animate the closing constraint to 0, causing the bottom of the header to be flush with the bottom of the overall disclosure view.
      self.closingConstraint.animator.constant = 0;
    } completionHandler:^{
      _disclosureIsClosed = YES;
    }];
  }
  else
  {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
      context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
      // Animate the constraint to fit the disclosed view again
      self.closingConstraint.animator.constant -= self.disclosedView.frame.size.height;
    } completionHandler:^{
      // The constraint is no longer needed, we can remove it.
      [self.view removeConstraint:self.closingConstraint];
      _disclosureIsClosed = NO;
    }];
  }
}

@end
