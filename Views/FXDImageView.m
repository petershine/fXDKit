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
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];

	if (self) {
		// Primitives

		// Instance variables

		// Properties

		// IBOutlets
		//MARK: awakeFromNib is called automatically
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		// Primitives

		// Instance variables

		// Properties

		// IBOutlets
        [self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	// Primitives

    // Instance variables

    // Properties

    // IBOutlets
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
		CGFloat aspectRatio = (float)self.image.size.width / (float)self.image.size.height;
		
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
		
		self.image = resizeableImage;
	}
}
	 
@end