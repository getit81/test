//
//  ClockView.h
//  AlarmClock
//
//  Created by David Brünner on 13.09.14.
//  Copyright (c) 2014 David Brünner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockView : UIView

	@property(nonatomic, strong) NSDate *time;
	@property(nonatomic, strong) NSCalendar *calendar;

	- (void)startAnimation;
	- (void)stopAnimation;
@end
