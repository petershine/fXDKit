

#import "FXDimportAdopted.h"


#if USE_LocationFrameworks
@implementation CLLocation (LocationFrameworks)
- (NSString*)formattedDistanceTextFromLocation:(CLLocation*)location {

	NSString *distanceText = nil;

	CLLocationDistance distance = [self distanceFromLocation:location];

	//FIXME: use miles for US users"

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
#endif


#if USE_MultimediaFrameworks
@implementation CALayer (MultimediaFrameworks)
- (void)applyFadeInOutWithFadeInTime:(CFTimeInterval)fadeInTime withFadeOutTime:(CFTimeInterval)fadeOutTime withDuration:(CFTimeInterval)duration {	FXDLog_DEFAULT;
	//NOTE: Use removedOnCompletion & fillMode appropriately
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

	//NOTE: Necessary for playback to be audible if silence is switched on
	//same as disabled condition. Evalute if this method is needed
	NSString *category = AVAudioSessionCategoryPlayAndRecord;

	NSError *error = nil;
	[self
	 setCategory:category
	 error:&error];FXDLog_ERROR;LOGEVENT_ERROR;

	FXDLog(@"2.%@", _Object(self.category));
}

- (void)disableAudioPlaybackCategory {	FXDLog_DEFAULT;
	//FXDAssert_IsMainThread;

	NSString *category = AVAudioSessionCategoryPlayAndRecord;

	NSError *error = nil;
	[self
	 setCategory:category
	 error:&error];FXDLog_ERROR;LOGEVENT_ERROR;

	FXDLog(@"2.%@ %@", _Object(self.category), _BOOL([category isEqualToString:self.category]));
}
@end


#endif
