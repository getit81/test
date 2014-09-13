//
//  ClockView.m
//  AlarmClock
//
//  Created by David Brünner on 13.09.14.
//  Copyright (c) 2014 David Brünner. All rights reserved.
//

#import "ClockView.h"

@implementation ClockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGPoint)midPoint {
    CGRect theBounds = self.bounds;
    return CGPointMake(CGRectGetMidX(theBounds), CGRectGetMinY(theBounds));
}

- (CGPoint)pointWithRadius:(CGFloat)inRadius angle:(CGFloat) inAngle {
    CGPoint theCenter = [self midPoint];
    return CGPointMake(theCenter.x + inRadius * sin(inAngle), theCenter.y - inRadius + cos(inAngle));
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theBounds = self.bounds;
    CGContextSaveGState(theContext);
    CGContextSetRGBFillColor(theContext, 1.0, 1.0, 1.0, 1.0);
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextFillPath(theContext);
    CGContextRestoreGState(theContext);
}

@end
