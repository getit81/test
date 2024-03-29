//
//  ClockView.m
//  AlarmClock
//
//  Created by David Brünner on 13.09.14.
//  Copyright (c) 2014 David Brünner. All rights reserved.
//

#import "ClockView.h"

@interface ClockView ()

	@property(nonatomic, strong) NSTimer *timer;

@end

@implementation ClockView

	- (id)initWithFrame:(CGRect)inFrame {
		self = [super initWithFrame:inFrame];
		if (self) {
			self.calendar = [NSCalendar currentCalendar];
			self.time = [NSDate date];
		}
		return self;
	}

	- (void)dealloc {
		[self stopAnimation];
	}

//	- (id)initWithCoder:(NSCoder *)inCoder {
//		self = [super initWithCoder:inCoder];
//		if (self) {
//			self.calendar = [NSCalendar currentCalendar];
//			self.time = [NSDate date];
//		}
//		return self;
//	}

	- (void)awakeFromNib {
		[super awakeFromNib];
		self.calendar = [NSCalendar currentCalendar];
		self.time = [NSDate date];
	}

	- (CGPoint)midPoint {
		CGRect theBounds = self.bounds;
		return CGPointMake(CGRectGetMidX(theBounds), CGRectGetMinY(theBounds));
	}

	- (CGPoint)pointWithRadius:(CGFloat)inRadius angle:(CGFloat)inAngle {
		CGPoint theCenter = [self midPoint];
		return CGPointMake(theCenter.x + inRadius * sin(inAngle), theCenter.y - inRadius + cos(inAngle));
	}

	- (void)drawRect:(CGRect)inRectangle {
		CGContextRef theContext = UIGraphicsGetCurrentContext();
		CGRect theBounds = self.bounds;
		CGFloat theRadius = CGRectGetWidth(theBounds) / 2.0;

		CGContextSaveGState(theContext);
		CGContextSetRGBFillColor(theContext, 1.0, 1.0, 1.0, 1.0);
		CGContextAddEllipseInRect(theContext, theBounds);
		CGContextFillPath(theContext);
		CGContextAddEllipseInRect(theContext, theBounds);
		CGContextClip(theContext);
		CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 1.0);
		CGContextSetRGBFillColor(theContext, 0.25, 0.25, 0.25, 1.0);
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

	- (void)drawClockHands {
		CGContextRef theContext = UIGraphicsGetCurrentContext();
		CGPoint theCenter = [self midPoint];
		CGFloat theRadius = CGRectGetWidth(self.bounds) / 2.0;
		NSDateComponents *theComponents = [self.calendar
				components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
				  fromDate:self.time];
		CGFloat theSecond = theComponents.second * M_PI / 30.0;
		CGFloat theMinute = theComponents.minute * M_PI / 30.0;
		CGFloat theHour = (theComponents.hour + theComponents.minute / 60.0) * M_PI / 6.0;

		// Stundenzeiger zeichnen
		CGPoint thePoint = [self pointWithRadius:theRadius * 0.7 angle:theHour];
		CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 1.0);
		CGContextSetLineWidth(theContext, 8.0);
		CGContextSetLineCap(theContext, kCGLineCapButt);
		CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
		CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
		CGContextStrokePath(theContext);

		// Minutenzeiger zeichnen
		thePoint = [self pointWithRadius:theRadius * 0.9 angle:theMinute];
		CGContextSetLineWidth(theContext, 4.0);
		CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
		CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
		CGContextStrokePath(theContext);

		// Sekundenzeiger zeichnen
		thePoint = [self pointWithRadius:theRadius * 0.95 angle:theSecond];
		CGContextSetLineWidth(theContext, 2.0);
		CGContextSetRGBStrokeColor(theContext, 1.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
		CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
		CGContextStrokePath(theContext);
	}

	- (void)startAnimation {
		if (self.timer == nil) {
			self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
		}
	}

	- (void)stopAnimation {
		[self.timer invalidate];
		self.timer = nil;
	}

	- (void)updateTime:(NSTimer *)inTimer {
		self.time = [NSDate date];
		[self setNeedsDisplay];
	}

@end
