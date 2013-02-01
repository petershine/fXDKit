//
//  FXDAnnotationView.m
//
//
//  Created by petershine on 5/11/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAnnotationView.h"


#pragma mark - Public implementation
@implementation FXDAnnotationView


#pragma mark - Memory management


#pragma mark - Initialization
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	
	if (self) {
		[self awakeFromNib];
	}
	
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets
	
}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation MKAnnotationView (Added)
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDefaultImage:(UIImage*)defaultImage {
	self = [self initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	
	if (self) {
#ifdef image_MapViewDefaultPin
		if (defaultImage == nil) {
			defaultImage = image_MapViewDefaultPin;
		}
#endif
		[self awakeFromNib];
		
		self.image = defaultImage;
	}
	
	return self;
}

- (void)animateCustomDropAfterDelay:(NSTimeInterval)delay {
	CGRect animatedFrame = self.frame;
	
	// Move annotation out of view
	//FXDLog(@"superview.superview: %@", NSStringFromCGRect(self.superview.superview.frame));
	
	CGRect modifiedFrame = self.frame;
	modifiedFrame.origin.y -= self.superview.superview.frame.size.height *2.0;
	[self setFrame:modifiedFrame];
	
	// Animate drop
	[UIView
	 animateWithDuration:durationAnimation
	 delay:delay
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 [self setFrame:animatedFrame];
	 }
	 completion:^(BOOL finished){
		 if (finished) {
			 [UIView
			  animateWithDuration:0.05
			  animations:^{
				  self.transform = CGAffineTransformMakeScale(1.0, 0.8);
			  }
			  completion:^(BOOL finished){
				  if (finished) {
					  [UIView
					   animateWithDuration:0.1
					   animations:^{
						   self.transform = CGAffineTransformIdentity;
					   }];
				  }
			  }];
		 }
	 }];
}

@end
