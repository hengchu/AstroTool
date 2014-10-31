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

@interface MDSScalingViewController ()

@property (weak) IBOutlet NSSlider *biasSlider;
@property (weak) IBOutlet NSSlider *contrastSlider;
@property (weak) IBOutlet MDSBorderColorableTextField *exponentField;

@property (nonatomic) CGFloat bias;
@property (nonatomic) CGFloat contrast;

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
  
  self.exponentField.borderColor = [MDSTheme separatorColor];
  self.exponentField.formatter = [[MDSDoubleValidationFormatter alloc] init];
}

@end
