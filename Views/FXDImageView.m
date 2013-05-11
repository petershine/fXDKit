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
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        [self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

		
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
	FXDLog(@"self.image: %@", self.image);
	
	self.contentMode = UIViewContentModeScaleAspectFit;
	
	if (self.image) {
		CGFloat aspectRatio = (CGFloat)self.image.size.width / (CGFloat)self.image.size.height;
		
		CGRect modifiedFrame = self.frame;
		FXDLog(@"(before)modifiedFrame: %@", NSStringFromCGRect(modifiedFrame));
		
		modifiedFrame.size.height = modifiedFrame.size.width / aspectRatio;
		FXDLog(@"(after)modifiedFrame: %@", NSStringFromCGRect(modifiedFrame));
		
		[self setFrame:modifiedFrame];
	}
}

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets {	//FXDLog_DEFAULT;
	//FXDLog(@"capInsets: %@", NSStringFromUIEdgeInsets(capInsets));
	
	if (self.image) {
		UIImage *resizeableImage = [self.image resizableImageWithCapInsets:capInsets];

		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			self.image = resizeableImage;
		}];
	}
}

#warning "//TODO: find optimal way of using layer instead of extra imageView object"
- (void)fadeInImage:(UIImage*)fadedImage {
	
	__block UIImageView *fadedImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
	
	fadedImageview.contentMode = self.contentMode;
	fadedImageview.backgroundColor = [UIColor clearColor];

	fadedImageview.alpha = 0.0;

	fadedImageview.image = fadedImage;

	[self addSubview:fadedImageview];

	[UIView animateWithDuration:durationQuickAnimation
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 fadedImageview.alpha = 1.0;
					 } completion:^(BOOL finished) {
						 //FXDLog(@"finished: %d fadedImageview: %@", finished, fadedImageview);
						 self.image = fadedImageview.image;

						 [fadedImageview removeFromSuperview];
						 fadedImageview = nil;
					 }];
}

@end


@implementation FXDimageviewTemp

#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
		
#if USE_tempImageview
#else
	self.image = nil;
#endif
}

@end