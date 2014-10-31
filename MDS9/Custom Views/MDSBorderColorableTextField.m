//
//  MDSBorderColorableTextField.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/31/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSBorderColorableTextField.h"

@implementation MDSBorderColorableTextField

- (void)drawRect:(NSRect)dirtyRect {
  
  [super drawRect:dirtyRect];

  NSPoint origin = { 0.0,0.0 };
  NSRect rect;
  rect.origin = origin;
  rect.size.width  = [self bounds].size.width;
  rect.size.height = [self bounds].size.height;
  
  NSBezierPath * path;
  path = [NSBezierPath bezierPathWithRect:rect];
  [path setLineWidth:2];
  [[NSColor colorWithCalibratedWhite:1.0 alpha:0.394] set];
  [path fill];
  [self.borderColor set];
  [path stroke];
  
  if (([[self window] firstResponder] == [self currentEditor]) && [NSApp isActive])
  {
    [NSGraphicsContext saveGraphicsState];
    NSSetFocusRingStyle(NSFocusRingOnly);
    [path fill];
    [NSGraphicsContext restoreGraphicsState];
  }
  else
  {
    [[self attributedStringValue] drawInRect:rect];
  }
}

@end
