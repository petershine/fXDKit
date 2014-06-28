//
//  FXDimportAdopted.m
//  fXDKit
//
//  Created by petershine on 6/28/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDimportAdopted.h"


#if USE_MultimediaFrameworks
@implementation CALayer (MultimediaFrameworks)
- (void)applyFadeInOutWithFadeInTime:(CFTimeInterval)fadeInTime withFadeOutTime:(CFTimeInterval)fadeOutTime withDuration:(CFTimeInterval)duration {	FXDLog_DEFAULT;
	//MARK: Use removedOnCompletion & fillMode appropriately
	//http://stackoverflow.com/a/14598962/259765
	[self setOpacity:0.0];

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
+ (NSURL*)uniqueMovieFileURLwithPrefix:(NSString*)prefix {
	NSString *filename = [NSString uniqueFilenameWithWithPrefix:prefix forType:(__bridge CFStringRef)filetypeVideoDefault];

	NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];

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

#endif
