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
    CGFloat theRadius = CGRectGetWidth(theBounds) / 2.0;
    
    CGContextSaveGState(theContext);
    CGContextSetRGBFillColor(theContext, 1.0, 1.0, 1.0, 1.0);
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextFillPath(theContext);
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextClip(theContext);
    CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 0.25);
    CGContextSetRGBFillColor(theContext, 0.25, 0.25, 0.25, 0.25);
    CGContextSetLineWidth(theContext, 8.0);
    CGContextSetLineCap(theContext, kCGLineCapRound);
    for (NSInteger i = 0; i < 60; ++i) {
        CGFloat theAngle = i * M_PI / 30.0;
        
        if (i % 5 == 0) {
            CGFloat theInnerRadius = theRadius * ((i % 15 == 0) ? 0.7 : 0.8);
            CGPoint theInnerPoint = [self pointWithRadius:theInnerRadius angle:theAngle];
            CGPoint theOuterPoint = [self pointWithRadius:theRadius angle:theAngle];
            CGContextMoveToPoint(theContext, theInnerPoint.x, theInnerPoint.y);
            CGContextAddLineToPoint(theContext, theOuterPoint.x, theOuterPoint.y);
            CGContextStrokePath(theContext);
        } else {
            CGPoint thePoint = [self pointWithRadius:theRadius * 0.95 angle:theAngle];
            CGContextAddArc(theContext, thePoint.x, thePoint.y, 3.0, 0.0, 2 * M_PI, YES);
            CGContextFillPath(theContext);
        }
    }
    [self drawClockHands];
    CGContextRestoreGState(theContext);
}

@end
