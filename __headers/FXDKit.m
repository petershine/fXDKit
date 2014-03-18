
#import "FXDKit.h"


@implementation NSIndexPath (Added)
- (NSString*)stringValue {	//FXDLog_DEFAULT;
	NSString *indexPathString = @"";

	for (NSInteger i = 0; i < [self length]; i++) {
		NSUInteger index = [self indexAtPosition:i];

		if (index == NSNotFound) {
			break;
		}

		if ([indexPathString length] > 0) {
			indexPathString = [indexPathString stringByAppendingString:@"_"];
		}

		indexPathString = [indexPathString stringByAppendingFormat:@"%lu", (unsigned long)index];
	}

	if ([indexPathString length] == 0) {
		indexPathString = nil;
	}

	//FXDLog(@"indexPathString: %@", indexPathString);

	return indexPathString;
}
@end


@implementation NSError (Added)
- (NSDictionary*)essentialParameters {
	NSDictionary *parameters =
	@{
	  @"localizedDescription": (([self localizedDescription]) ? [self localizedDescription]:@""),
	  @"domain":	(([self domain]) ? [self domain]:@""),
	  @"code":	@([self code]),
	  @"userInfo":	(([self userInfo]) ? [self userInfo]:@"")
	  };

	return parameters;
}
@end


@implementation NSDate (Added)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate {
	if (localDate == nil) {
		localDate = [self date];
	}

	NSDateFormatter *dateFormatter = [NSDateFormatter new];

    NSTimeZone *UTCtimezone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:UTCtimezone];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *shortUTCdateString = [dateFormatter stringFromDate:localDate];

    return shortUTCdateString;
}

+ (NSString*)shortLocalDateStringForUTCdate:(NSDate*)UTCdate {
	if (UTCdate == nil) {
		UTCdate = [self date];
	}

	NSDateFormatter *dateFormatter = [NSDateFormatter new];

    NSTimeZone *UTCtimezone = [NSTimeZone defaultTimeZone];
    [dateFormatter setTimeZone:UTCtimezone];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *shortLocalDateString = [dateFormatter stringFromDate:UTCdate];

    return shortLocalDateString;
}

#pragma mark -
- (NSInteger)yearValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];

	return [dateComponents year];
}

- (NSInteger)monthValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];

	return [dateComponents month];
}

- (NSInteger)dayValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];

	return [dateComponents day];
}

#pragma mark -
- (NSString*)shortMonthString {

	NSArray *monthStringArray = @[@"",
								  @"Jan",
								  @"Feb",
								  @"Mar",
								  @"Apr",
								  @"May",
								  @"Jun",
								  @"Jul",
								  @"Aug",
								  @"Sep",
								  @"Oct",
								  @"Nov",
								  @"Dec"];

	NSString *monthString = monthStringArray[[self monthValue]];

	return monthString;
}

- (NSString*)weekdayString {

	NSArray *weekdayStringArray = @[@"",
									@"Sunday",
									@"Monday",
									@"Tuesday",
									@"Wednesday",
									@"Thursday",
									@"Friday",
									@"Saturday"];

	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];

	NSString *weekdayString = weekdayStringArray[[dateComponents weekday]];

	return weekdayString;
}

#pragma mark -
- (NSInteger)hourValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self];

	return [dateComponents hour];
}

- (NSInteger)minuteValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self];

	return [dateComponents minute];
}

- (NSInteger)secondValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self];

	return [dateComponents second];
}

#pragma mark -
- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate {
	BOOL isSame = NO;

	if ([self yearValue] == [anotherDate yearValue]
		&& [self monthValue] == [anotherDate monthValue]
		&& [self dayValue] == [anotherDate dayValue]) {
		isSame = YES;
	}
	
	return isSame;
}
@end


@implementation UIColor (Added)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue {
	return [self colorUsingIntegersForRed:red forGreen:green forBlue:blue forAlpha:1];
}

+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue forAlpha:(CGFloat)alpha {
	return [UIColor
			colorWithRed:(CGFloat)red/255.0
			green:(CGFloat)green/255.0
			blue:(CGFloat)blue/255.0
			alpha:alpha];
}

+ (UIColor*)colorUsingHEX:(NSInteger)rgbValue forAlpha:(CGFloat)alpha {
	return [UIColor
			colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0
			green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0
			blue:((CGFloat)(rgbValue & 0xFF))/255.0
			alpha:alpha];
}
@end


@implementation UIBarButtonItem (Added)
- (void)customizeWithNormalImage:(UIImage*)normalImage andWithHighlightedImage:(UIImage*)highlightedImage {

	if (self.customView == nil) {
		self.customView = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normalImage.size.width, normalImage.size.height)];
		[(UIButton*)self.customView addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
	}

	[(UIButton*)self.customView setImage:normalImage forState:UIControlStateNormal];
	[(UIButton*)self.customView setImage:highlightedImage forState:UIControlStateHighlighted];
}
@end


@implementation UIApplication (Added)
- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay {
	if (alertBody == nil) {
		return;
	}


	UILocalNotification *localNotifcation = [UILocalNotification new];
	localNotifcation.repeatInterval = 0;
	localNotifcation.alertBody = alertBody;

	if (delay > 0.0) {
		localNotifcation.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];

		[self scheduleLocalNotification:localNotifcation];
	}
	else {
		[self presentLocalNotificationNow:localNotifcation];
	}
}
@end


#if USE_MultimediaFrameworks
#pragma mark -
@implementation UIDevice (Added)
- (CGAffineTransform)affineTransformForOrientation {	//FXDLog_DEFAULT;

	CGAffineTransform affineTransform =
	[self
	 affineTransformForOrientation:self.orientation
	 forPosition:AVCaptureDevicePositionBack];

	return affineTransform;
}

- (CGAffineTransform)affineTransformForOrientationAndForPosition:(AVCaptureDevicePosition)cameraPosition {

	CGAffineTransform affineTransform =
	[self
	 affineTransformForOrientation:self.orientation
	 forPosition:cameraPosition];

	return affineTransform;
}

- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition {

	CGAffineTransform affineTransform = CGAffineTransformIdentity;

	switch (deviceOrientation) {
		case UIDeviceOrientationLandscapeLeft:
			affineTransform = CGAffineTransformMakeRotation( 0 / 180 );

			if (cameraPosition == AVCaptureDevicePositionFront) {
				affineTransform = CGAffineTransformMakeRotation( ( -180 * M_PI ) / 180 );
			}
			break;

		case UIDeviceOrientationLandscapeRight:
			affineTransform = CGAffineTransformMakeRotation( ( -180 * M_PI ) / 180 );

			if (cameraPosition == AVCaptureDevicePositionFront) {
				affineTransform = CGAffineTransformMakeRotation( 0 / 180 );
			}
			break;

		case UIDeviceOrientationPortraitUpsideDown:
			affineTransform = CGAffineTransformMakeRotation( ( -90 * M_PI ) / 180 );
			break;

		case UIDeviceOrientationUnknown:
		case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationFaceDown:
		case UIDeviceOrientationPortrait:
		default: {
			affineTransform =  CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
			break;
		}
	}

	//FXDLog(@"affineTransform: %@", NSStringFromCGAffineTransform(affineTransform));
	return affineTransform;
}

#pragma mark -
- (CGRect)screenFrameForOrientation {	//FXDLog_DEFAULT;

	CGRect screenFrame = [self screenFrameForOrientation:self.orientation];

	return screenFrame;
}

- (CGRect)screenFrameForOrientation:(UIDeviceOrientation)deviceOrientation {

	CGRect screenFrame = [UIScreen mainScreen].bounds;

	CGFloat screenWidth = screenFrame.size.width;
	CGFloat screenHeight = screenFrame.size.height;

	if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
		screenFrame.size.width = screenHeight;
		screenFrame.size.height = screenWidth;
	}

	//FXDLog(@"screenFrame: %@", NSStringFromCGRect(screenFrame));

	return screenFrame;
}
@end

#endif
