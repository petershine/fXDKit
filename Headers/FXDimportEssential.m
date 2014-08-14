

#import "FXDimportEssential.h"


@implementation NSError (Essential)
- (NSDictionary*)essentialParameters {
	NSDictionary *parameters =
	@{
	  @"Description":	(([self localizedDescription]) ? [self localizedDescription]:@""),
	  @"FailureReason":	(([self localizedFailureReason]) ? [self localizedFailureReason]:@""),
	  @"Domain":		(([self domain]) ? [self domain]:@""),
	  @"Code":			@([self code]),
	  @"UserInfo":		(([self userInfo]) ? [self userInfo]:@"")
	  };

	return parameters;
}
@end


@implementation CATextLayer (Essential)
+ (instancetype)newTextLayerFromTextControl:(id)textControl forRenderingScale:(CGFloat)renderingScale {

	if ([textControl isKindOfClass:[UITextField class]] == NO
		&& [textControl isKindOfClass:[UITextView class]] == NO) {	FXDLog_DEFAULT;
		FXDLogObject(textControl);
		return nil;
	}


	CATextLayer *textLayer = [[CATextLayer alloc] init];
	textLayer.string = [textControl text];

	CGRect scaledBounds = [textControl bounds];
	scaledBounds.size.width *= renderingScale;
	scaledBounds.size.height *= renderingScale;
	textLayer.frame = scaledBounds;


	textLayer.font = (__bridge CFTypeRef)([textControl font]);
	textLayer.fontSize = [textControl font].pointSize*renderingScale;

	textLayer.foregroundColor = [[textControl textColor] CGColor];


	NSString *alignmentMode = kCAAlignmentNatural;

	switch ([textControl textAlignment]) {
		case NSTextAlignmentLeft:
			alignmentMode = kCAAlignmentLeft;
			break;

		case NSTextAlignmentCenter:
			alignmentMode = kCAAlignmentCenter;
			break;

		case NSTextAlignmentRight:
			alignmentMode = kCAAlignmentRight;
			break;

		case NSTextAlignmentJustified:
			alignmentMode = kCAAlignmentJustified;
			break;

		case NSTextAlignmentNatural:
			alignmentMode = kCAAlignmentNatural;
			break;

		default:
			break;
	}

	[textLayer setAlignmentMode:alignmentMode];

	if ([textControl isKindOfClass:[UITextView class]]) {
		textLayer.wrapped = YES;
	}


	return textLayer;
}
@end


@implementation NSFetchedResultsController (Essential)
- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue {

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attributeKey, attributeValue];

	NSManagedObject *resultObj = [self resultObjForPredicate:predicate];

	return resultObj;
}

- (NSManagedObject*)resultObjForPredicate:(NSPredicate*)predicate {

	NSManagedObject *resultObj = nil;

	if (self.fetchedObjects.count > 0) {
		NSArray *filteredArray = [self.fetchedObjects filteredArrayUsingPredicate:predicate];

		resultObj = [filteredArray firstObject];
	}

	return resultObj;
}
@end


@implementation UIColor (Essential)
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

+ (UIColor*)colorUsingHEX:(NSInteger)rgbValue forAlpha:(CGFloat)alpha {	// Use 0xFF0000 type
	return [UIColor
			colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0
			green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0
			blue:((CGFloat)(rgbValue & 0xFF))/255.0
			alpha:alpha];
}
@end


@implementation UIStoryboard (Essential)
+ (UIStoryboard*)storyboardWithDefaultName {	FXDLog_SEPARATE;
	NSString *storyboardName = NSStringFromClass([self class]);

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		storyboardName = [storyboardName stringByAppendingString:@"_iPad"];
	}

	FXDLogObject(storyboardName);

	UIStoryboard *storyboard = [self storyboardWithName:storyboardName bundle:nil];

	return storyboard;
}
@end


@implementation UIBarButtonItem (Essential)
- (void)customizeWithNormalImage:(UIImage*)normalImage andWithHighlightedImage:(UIImage*)highlightedImage {

	if (self.customView == nil) {
		self.customView = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normalImage.size.width, normalImage.size.height)];
		[(UIButton*)self.customView addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
	}

	[(UIButton*)self.customView setImage:normalImage forState:UIControlStateNormal];
	[(UIButton*)self.customView setImage:highlightedImage forState:UIControlStateHighlighted];
}
@end


@implementation UIApplication (Essential)
+ (UIWindow*)mainWindow {
	UIWindow *mainWindow = nil;

	if ([[[self class] sharedApplication].delegate respondsToSelector:@selector(window)]) {
		mainWindow = [[[self class] sharedApplication].delegate performSelector:@selector(window)];
	}

	return mainWindow;
}

- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay {
	if (alertBody == nil) {
		return;
	}


	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 UILocalNotification *localNotifcation = [[UILocalNotification alloc] init];
		 localNotifcation.repeatInterval = 0;
		 localNotifcation.alertBody = alertBody;

		 if (delay > 0.0) {
			 localNotifcation.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];

			 [self scheduleLocalNotification:localNotifcation];
		 }
		 else {
			 [self presentLocalNotificationNow:localNotifcation];
		 }
	 }];
}
@end


@implementation UIScreen (Essential)
+ (CGRect)screenBoundsForOrientation:(UIDeviceOrientation)deviceOrientation {

	CGRect screenBounds = [[self class] mainScreen].bounds;

	CGFloat screenWidth = screenBounds.size.width;
	CGFloat screenHeight = screenBounds.size.height;

	if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
		screenBounds.size.width = screenHeight;
		screenBounds.size.height = screenWidth;
	}

	return screenBounds;
}
@end


@implementation UIDevice (Essential)
+ (UIDeviceOrientation)validDeviceOrientation {
	UIDeviceOrientation validOrientation = [[self class] currentDevice].orientation;

	if (UIDeviceOrientationIsValidInterfaceOrientation(validOrientation) == NO) {
		validOrientation = UIDeviceOrientationPortrait;
	}

	return validOrientation;
}

- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation {
	CGAffineTransform affineTransform = CGAffineTransformIdentity;

	switch (deviceOrientation) {
		case UIDeviceOrientationLandscapeLeft:
			affineTransform = CGAffineTransformMakeRotation( 0 / 180 );
			break;

		case UIDeviceOrientationLandscapeRight:
			affineTransform = CGAffineTransformMakeRotation( ( -180 * M_PI ) / 180 );
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
	
	return affineTransform;
}

@end
