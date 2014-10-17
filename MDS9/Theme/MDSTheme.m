//
//  MDSTheme.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/14/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSTheme.h"

#define RGB(r, g, b) [NSColor colorWithCalibratedRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [NSColor colorWithCalibratedRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation MDSTheme

+ (NSColor *)panelColor
{
  return [NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1];
}

+ (NSColor *)stackHeaderButtonTextColor
{
  return RGB(152, 165, 178);
}

+ (NSColor *)separatorColor
{
  return RGB(197, 197, 197);
}

@end
