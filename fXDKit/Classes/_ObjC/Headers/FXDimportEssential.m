

#import "FXDimportEssential.h"


@implementation NSNumberFormatter (Grouping)
+ (NSNumberFormatter*)formatterGroupingSize:(NSInteger)groupingSize separator:(NSString*)separator {
	NSNumberFormatter *grouping = [[NSNumberFormatter alloc] init];
	grouping.groupingSize = groupingSize;
	grouping.groupingSeparator = separator;
	grouping.usesGroupingSeparator = YES;
	return grouping;
}
@end


@implementation NSDictionary (NullCleaning)
+ (NSDictionary *)cleanNullInJsonDic:(NSDictionary *)dic {
	if (!dic || (id)dic == [NSNull null]) {
		return dic;
	}


	NSMutableDictionary *mulDic = [[NSMutableDictionary alloc] init];

	for (NSString *key in dic.allKeys) {
		NSObject *obj = dic[key];
		if (!obj || obj == [NSNull null])
		{
			//            [mulDic setObject:[@"" JSONValue] forKey:key];
		}else if ([obj isKindOfClass:[NSDictionary class]])
		{
			mulDic[key] = [self cleanNullInJsonDic:(NSDictionary *)obj];
		}else if ([obj isKindOfClass:[NSArray class]])
		{
			NSArray *array = [self cleanNullInJsonArray:(NSArray *)obj];
			mulDic[key] = array;
		}else
		{
			mulDic[key] = obj;
		}
	}

	return mulDic;
}

+ (NSArray *)cleanNullInJsonArray:(NSArray *)array {

	if (!array || (id)array == [NSNull null]) {
		return array;
	}


	NSMutableArray *mulArray = [[NSMutableArray alloc] init];

	for (NSObject *obj in array) {
		if (!obj || obj == [NSNull null])
		{
			//            [mulArray addObject:[@"" JSONValue]];
		}else if ([obj isKindOfClass:[NSDictionary class]])
		{
			NSDictionary *dic = [self cleanNullInJsonDic:(NSDictionary *)obj];
			[mulArray addObject:dic];
		}else if ([obj isKindOfClass:[NSArray class]])
		{
			NSArray *a = [self cleanNullInJsonArray:(NSArray *)obj];
			[mulArray addObject:a];
		}else
		{
			[mulArray addObject:obj];
		}
	}
	return mulArray;
}
@end


@implementation NSError (Essential)
- (NSDictionary*)essentialParameters {
	NSDictionary *parameters =
	@{
	  @"Description"	:		((self.localizedDescription) ? self. localizedDescription:@""),
	  @"FailureReason"	:		((self.localizedFailureReason) ? self. localizedFailureReason:@""),
	  @"RecoverySuggestion"	:	((self.localizedRecoverySuggestion) ? self.localizedRecoverySuggestion:@""),
	  @"Domain"	:				((self.domain) ? self.domain:@""),
	  @"Code"	:				@(self.code),
	  @"UserInfo"	:			((self.userInfo) ? self.userInfo:@""),
	  @"HelpAnchor"	:			((self.helpAnchor) ? self.helpAnchor:@""),
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

	CGRect scaledBounds = ((UIView*)textControl).bounds;
	scaledBounds.size.width *= renderingScale;
	scaledBounds.size.height *= renderingScale;
	textLayer.frame = scaledBounds;
	textLayer.font = (CFTypeRef)([textControl font]);
	textLayer.fontSize = ((UIFont*)[textControl font]).pointSize*renderingScale;
	textLayer.foregroundColor = [textControl textColor].CGColor;


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

	textLayer.alignmentMode = alignmentMode;

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

		resultObj = filteredArray.firstObject;
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
- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay {

	if (alertBody == nil) {
		return;
	}

	if (delay <= 0.0) {
		delay = 0.25;	//MARK: timeInterval must be greater than 0.0
	}

	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
		 content.body = alertBody;
		 content.sound = [UNNotificationSound defaultSound];

		 UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:delay repeats:NO];

		 UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"fXDLocalNotification" content:content trigger:trigger];

		 [[UNUserNotificationCenter currentNotificationCenter]
		  addNotificationRequest:request
		  withCompletionHandler:^(NSError * _Nullable error) {	FXDLog_BLOCK(self, @selector(addNotificationRequest:withCompletionHandler:));

			  FXDLog_ERROR;
		  }];
	 }];
}
@end


@implementation UIScreen (Essential)
+ (CGRect)screenBoundsForOrientation:(UIDeviceOrientation)deviceOrientation {

	BOOL isForLandscape = (UIDeviceOrientationIsPortrait(deviceOrientation) == NO);

	CGRect screenBounds = [self screenBoundsForLandscape:isForLandscape];

	return screenBounds;
}

+ (CGRect)screenBoundsForLandscape:(BOOL)isForLanscape {
	CGRect screenBounds = [[self class] mainScreen].bounds;

	CGFloat screenWidth = screenBounds.size.width;
	CGFloat screenHeight = screenBounds.size.height;

	if (isForLanscape) {
		screenBounds.size.width = MAX(screenWidth, screenHeight);
		screenBounds.size.height = MIN(screenWidth, screenHeight);
	}

	return screenBounds;
}

+ (CGFloat)maximumScreenDimension {
	CGRect screenBounds = [[self class] mainScreen].bounds;

	CGFloat screenWidth = screenBounds.size.width;
	CGFloat screenHeight = screenBounds.size.height;

	return MAX(screenWidth, screenHeight);
}

+ (CGFloat)minimumScreenDimension {
	CGRect screenBounds = [[self class] mainScreen].bounds;
	
	CGFloat screenWidth = screenBounds.size.width;
	CGFloat screenHeight = screenBounds.size.height;

	return MIN(screenWidth, screenHeight);
}

@end


@implementation UIDevice (Essential)
+ (UIDeviceOrientation)validDeviceOrientation {
	UIDeviceOrientation validOrientation = [[self class] currentDevice].orientation;

	if (UIDeviceOrientationIsValidInterfaceOrientation(validOrientation) == NO) {
		validOrientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
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


@implementation UILabel (Essential)
- (void)applyShadowColor:(UIColor*)shadowColor {

	if (shadowColor == nil) {
		shadowColor = [UIColor clearColor];
	}

	NSShadow *textShadow = [[NSShadow alloc] init];
	textShadow.shadowBlurRadius = (marginDefault/2.0);
	textShadow.shadowColor = shadowColor;

	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = self.textAlignment;

	NSDictionary *textAttributes = @{	NSShadowAttributeName : textShadow,
										NSParagraphStyleAttributeName : paragraphStyle,
										NSForegroundColorAttributeName : self.textColor,
										NSFontAttributeName : self.font	};

	self.attributedText = [[NSAttributedString alloc]
						   initWithString:self.text
						   attributes:textAttributes];
}

- (void)attributeColor:(UIColor*)attributedColor forSubstring:(NSString*)substring {

	if (self.text == nil) {
		return;
	}
	

	if (substring.length == 0) {
		return;
	}


	NSRange substringRange = [self.text rangeOfString:substring];

	if (substringRange.location == NSNotFound) {
		return;
	}


	NSMutableAttributedString *colorAttributed = [[NSMutableAttributedString alloc] initWithString:self.text];
	[colorAttributed addAttribute:NSForegroundColorAttributeName value:attributedColor range:substringRange];
	self.attributedText = colorAttributed;
}

- (void)attributeUnderlineAndColor:(UIColor*)attributedColor forSubstring:(NSString*)substring {

	if (self.text == nil) {
		return;
	}


	if (substring.length == 0) {
		return;
	}


	NSRange substringRange = [self.text rangeOfString:substring];

	if (substringRange.location == NSNotFound) {
		return;
	}


	NSMutableAttributedString *colorAttributed = [[NSMutableAttributedString alloc] initWithString:self.text];
	[colorAttributed addAttribute:NSForegroundColorAttributeName value:attributedColor range:substringRange];
	[colorAttributed addAttribute:NSUnderlineStyleAttributeName value:@1 range:substringRange];
	self.attributedText = colorAttributed;
}

@end


@implementation CLLocation (LocationFrameworks)
- (NSString*)formattedDistanceTextFromLocation:(CLLocation*)location {

	NSString *distanceText = nil;

	CLLocationDistance distance = [self distanceFromLocation:location];

	//TODO: use miles for US users"

	if (distance >= 1000.0) {
		distance /= 1000.0;

		distanceText = [NSString stringWithFormat:@"%.1f km", distance];
	}
	else {
		distanceText = [NSString stringWithFormat:@"%.1f m", distance];

	}

	return distanceText;
}
@end


@implementation CALayer (MultimediaFrameworks)
- (void)applyFadeInOutWithFadeInTime:(CFTimeInterval)fadeInTime withFadeOutTime:(CFTimeInterval)fadeOutTime withDuration:(CFTimeInterval)duration {	FXDLog_DEFAULT;
	//MARK: Use removedOnCompletion & fillMode appropriately
	//http://stackoverflow.com/a/14598962/259765
	self.opacity = 0.0;

	CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeIn.fromValue = @(0.0);
	fadeIn.toValue = @(1.0);
	fadeIn.beginTime = (fadeInTime > 0.0 ? fadeInTime:AVCoreAnimationBeginTimeAtZero);
	fadeIn.duration = duration;
	fadeIn.removedOnCompletion = NO;
	fadeIn.fillMode = kCAFillModeForwards;
	[self addAnimation:fadeIn forKey:@"animationFadeIn"];

	CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeOut.fromValue = @(1.0);
	fadeOut.toValue = @(0.0);
	fadeOut.beginTime = fadeOutTime;
	fadeOut.duration = duration;
	fadeOut.removedOnCompletion = NO;
	fadeOut.fillMode = kCAFillModeForwards;
	[self addAnimation:fadeOut forKey:@"animationFadeOut"];

	FXDLog(@"%@ %@", _Variable(fadeIn.beginTime), _Variable(fadeOut.beginTime));
}
@end


@implementation NSURL (MultimediaFrameworks)
+ (NSURL*)uniqueMovieFileURLwithPrefix:(NSString*)prefix atDirectory:(NSString*)directory {
	NSString *filename = [NSString uniqueFilenameWithWithPrefix:prefix forType:(__bridge CFStringRef)AVFileTypeQuickTimeMovie];

	NSString *filePath = [directory stringByAppendingPathComponent:filename];

	NSURL *movieFileURL = [NSURL fileURLWithPath:filePath];
	FXDLogObject(movieFileURL);

	return movieFileURL;
}
@end

@implementation UIDevice (MultimediaFrameworks)
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition {

	CGAffineTransform affineTransform = [self affineTransformForOrientation:deviceOrientation];

	if (deviceOrientation == UIDeviceOrientationLandscapeLeft
		&& cameraPosition == AVCaptureDevicePositionFront) {
		affineTransform = CGAffineTransformMakeRotation( ( -180 * M_PI ) / 180 );
	}
	else if (deviceOrientation == UIDeviceOrientationLandscapeRight
			 && cameraPosition == AVCaptureDevicePositionFront) {
		affineTransform = CGAffineTransformMakeRotation( 0 / 180 );
	}

	return affineTransform;
}
@end


@implementation AVAudioSession (MultimediaFrameworks)
- (void)enableAudioPlaybackCategory {	FXDLog_DEFAULT;
	FXDAssert_IsMainThread;

	FXDLog(@"1.%@", _Object(self.category));

	//MARK: Necessary for playback to be audible if silence is switched on
	//same as disabled condition. Evalute if this method is needed
	NSString *category = AVAudioSessionCategoryPlayAndRecord;

	NSError *error = nil;
	[self
	 setCategory:category
	 error:&error];FXDLog_ERROR;

	FXDLog(@"2.%@", _Object(self.category));
}

- (void)disableAudioPlaybackCategory {	FXDLog_DEFAULT;
	//FXDAssert_IsMainThread;

	NSString *category = AVAudioSessionCategoryPlayAndRecord;

	NSError *error = nil;
	[self
	 setCategory:category
	 error:&error];FXDLog_ERROR;

	FXDLog(@"2.%@ %@", _Object(self.category), _BOOL([category isEqualToString:self.category]));
}
@end

