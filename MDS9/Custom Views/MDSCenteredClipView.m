//
//  MDCenteredScrollView.m
//  MDS9
//
//  Created by Hengchu Zhang on 10/20/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#import "MDSCenteredClipView.h"

@implementation MDSCenteredClipView

- (NSRect)constrainBoundsRect:(NSRect)proposedClipViewBoundsRect {
  // Early out if you want to use the regular behavior at any time.
  if (self.centersDocumentView == NO) {
    return [super constrainBoundsRect:proposedClipViewBoundsRect];
  }
  
  NSRect constrainedClipViewBoundsRect;
  NSRect documentViewFrameRect = [self.documentView frame];
  
  constrainedClipViewBoundsRect = [super constrainBoundsRect:proposedClipViewBoundsRect];
  
  // If proposed clip view bounds width is greater than document view frame width, center it horizontally.
  if (proposedClipViewBoundsRect.size.width >= documentViewFrameRect.size.width) {
    // Adjust the proposed origin.x
    constrainedClipViewBoundsRect.origin.x = centeredCoordinateUnitWithProposedContentViewBoundsDimensionAndDocumentViewFrameDimension(proposedClipViewBoundsRect.size.width, documentViewFrameRect.size.width);
  }
  
  // If proposed clip view bounds is hight is greater than document view frame height, center it vertically.
  if (proposedClipViewBoundsRect.size.height >= documentViewFrameRect.size.height) {
    
    // Adjust the proposed origin.y
    constrainedClipViewBoundsRect.origin.y = centeredCoordinateUnitWithProposedContentViewBoundsDimensionAndDocumentViewFrameDimension(proposedClipViewBoundsRect.size.height, documentViewFrameRect.size.height);
  }
  
  return constrainedClipViewBoundsRect;
}


CGFloat centeredCoordinateUnitWithProposedContentViewBoundsDimensionAndDocumentViewFrameDimension
(CGFloat proposedContentViewBoundsDimension,
 CGFloat documentViewFrameDimension )
{
  CGFloat result = floor( (proposedContentViewBoundsDimension - documentViewFrameDimension) / -2.0F );
  return result;
}

@end
