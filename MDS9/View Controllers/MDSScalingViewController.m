//
//  MDSScalingViewController.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/30/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSScalingViewController.h"
#import "MDSTheme.h"
#import "MDSBorderColorableTextField.h"
#import "MDSDoubleValidationFormatter.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MDSScalingViewController () <NSComboBoxDelegate>

@property (weak) IBOutlet NSSlider *biasSlider;
@property (weak) IBOutlet NSSlider *contrastSlider;
@property (weak) IBOutlet MDSBorderColorableTextField *exponentField;
@property (weak) IBOutlet NSComboBox *scaleComboBox;

@property (nonatomic) CGFloat bias;
@property (nonatomic) CGFloat contrast;
@property (nonatomic) MDSScaleType scaleType;

@end

@implementation MDSScalingViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do view setup here.
  
  self.bias = self.biasSlider.doubleValue;
  self.contrast = self.contrastSlider.doubleValue;
  
  self.biasSlider.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    self.bias = ((NSSlider *)input).doubleValue;
    return [RACSignal empty];
  }];
  
  self.contrastSlider.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    self.contrast = ((NSSlider *)input).doubleValue;
    return [RACSignal empty];
  }];
  
  self.scaleComboBox.delegate = self;
  [self.scaleComboBox selectItemWithObjectValue:@"Zscale"];
  
  self.exponentField.borderColor = [MDSTheme separatorColor];
  self.exponentField.formatter   = [[MDSDoubleValidationFormatter alloc] init];
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
  NSDictionary *selectedIndexToScaleType = @{
                                             @(0) : @(MDSLinearScale),
                                             @(1) : @(MDSLogScale),
                                             @(2) : @(MDSPowerScale),
                                             @(3) : @(MDSSqrtScale),
                                             @(4) : @(MDSSquaredScale),
                                             @(5) : @(MDSAsinhScale),
                                             @(6) : @(MDSZScale)
                                            };
  
  self.scaleType = [selectedIndexToScaleType[@(self.scaleComboBox.indexOfSelectedItem)] unsignedIntegerValue];
}

@end
