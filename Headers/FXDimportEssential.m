

#import "FXDimportEssential.h"


#import "FXDconfigDeveloper.h"

#import "FXDmacroValue.h"
#import "FXDmacroFunction.h"


#pragma mark - Categories
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

	for (NSString *key in [dic allKeys]) {
		NSObject *obj = dic[key];
		if (!obj || obj == [NSNull null])
		{
			//            [mulDic setObject:[@"" JSONValue] forKey:key];
		}else if ([obj isKindOfClass:[NSDictionary class]])
		{
			[mulDic setObject:[self cleanNullInJsonDic:(NSDictionary *)obj] forKey:key];
		}else if ([obj isKindOfClass:[NSArray class]])
		{
			NSArray *array = [self cleanNullInJsonArray:(NSArray *)obj];
			[mulDic setObject:array forKey:key];
		}else
		{
			[mulDic setObject:obj forKey:key];
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

	CGRect scaledBounds = [(UIView*)textControl bounds];
	scaledBounds.size.width *= renderingScale;
	scaledBounds.size.height *= renderingScale;
	textLayer.frame = scaledBounds;


	textLayer.font = (CFTypeRef)([textControl font]);
	textLayer.fontSize = [(UIFont*)[textControl font] pointSize]*renderingScale;

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
#if TARGET_APP_EXTENSION
#else
+ (UIWindow*)mainWindow {
	UIWindow *mainWindow = nil;

	if ([[[self class] sharedApplication].delegate respondsToSelector:@selector(window)]) {
		mainWindow = [[[self class] sharedApplication].delegate performSelector:@selector(window)];
	}

	return mainWindow;
}
#endif

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
#if TARGET_APP_EXTENSION
#else
+ (UIDeviceOrientation)validDeviceOrientation {
	UIDeviceOrientation validOrientation = [[self class] currentDevice].orientation;

	if (UIDeviceOrientationIsValidInterfaceOrientation(validOrientation) == NO) {
		validOrientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
	}

	return validOrientation;
}
#endif

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
	[colorAttributed addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:substringRange];
	self.attributedText = colorAttributed;
}

@end
