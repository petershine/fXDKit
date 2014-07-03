

#import "FXDImageView.h"


@implementation UIImageView (Essential)
- (void)modifyHeightForContainedImage {	FXDLog_DEFAULT;

	__weak UIImageView *weakSelf = self;

	weakSelf.contentMode = UIViewContentModeScaleAspectFit;

	FXDLogObject(weakSelf.image);
	if (weakSelf.image == nil) {
		return;
	}


	CGFloat aspectRatio = weakSelf.image.size.width/weakSelf.image.size.height;

	CGRect modifiedFrame = weakSelf.frame;
	FXDLog(@"1.%@", _Rect(modifiedFrame));

	modifiedFrame.size.height = modifiedFrame.size.width/aspectRatio;
	FXDLog(@"2.%@", _Rect(modifiedFrame));

	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 __strong UIImageView *strongSelf = weakSelf;

		 strongSelf.frame = modifiedFrame;
	 }];
}

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets {	FXDLog_DEFAULT;
	FXDLogStruct(capInsets);

	__weak UIImageView *weakSelf = self;

	FXDLogObject(weakSelf.image);
	if (weakSelf.image == nil) {
		return;
	}


	UIImage *resizeableImage = [weakSelf.image resizableImageWithCapInsets:capInsets];

	if (resizeableImage == nil) {
		return;
	}


	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 __strong UIImageView *strongSelf = weakSelf;

		 strongSelf.image = resizeableImage;
	 }];
}

@end
