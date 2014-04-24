//
//  FXDImageView.m
//
//
//  Created by petershine on 2/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDImageView.h"


#pragma mark - Public implementation
@implementation FXDImageView


#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        [self awakeFromNib];
    }
	
    return self;
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end

#pragma mark - Category
@implementation UIImageView (Added)
- (void)modifyHeightForContainedImage {	FXDLog_DEFAULT;
	FXDLogObject(self.image);
	
	self.contentMode = UIViewContentModeScaleAspectFit;
	
	if (self.image) {
		CGFloat aspectRatio = (CGFloat)self.image.size.width / (CGFloat)self.image.size.height;
		
		CGRect modifiedFrame = self.frame;
		FXDLog(@"(before) %@", _Rect(modifiedFrame));
		
		modifiedFrame.size.height = modifiedFrame.size.width / aspectRatio;
		FXDLog(@"(after) %@", _Rect(modifiedFrame));
		
		self.frame = modifiedFrame;
	}
}

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets {
	FXDLogStruct(capInsets);

	__weak typeof(self) weakSelf = self;
	
	if (weakSelf.image) {
		UIImage *resizeableImage = [weakSelf.image resizableImageWithCapInsets:capInsets];

		if (resizeableImage) {
			[[NSOperationQueue mainQueue]
			 addOperationWithBlock:^{
				 __strong typeof(weakSelf) strongSelf = weakSelf;
				 
				 strongSelf.image = resizeableImage;
			 }];
		}
	}
}

//TODO: find optimal way of using layer instead of extra imageView object
- (void)fadeInImage:(UIImage*)fadedImage {
	
	__weak typeof(self) weakSelf = self;
	
	UIImageView *fadedImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
	
	fadedImageview.contentMode = weakSelf.contentMode;
	fadedImageview.backgroundColor = [UIColor clearColor];
	
	fadedImageview.alpha = 0.0;
	
	fadedImageview.image = fadedImage;
	
	[weakSelf addSubview:fadedImageview];
	
	[UIView
	 animateWithDuration:durationQuickAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 fadedImageview.alpha = 1.0;
	 }
	 completion:^(BOOL finished) {
		 __strong typeof(weakSelf) strongSelf = weakSelf;
		 
		 strongSelf.image = fadedImageview.image;
		 
		 [fadedImageview removeFromSuperview];
	 }];
}

@end
