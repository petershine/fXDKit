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
- (instancetype)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	
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
@implementation MKAnnotationView (Added)
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDefaultImage:(UIImage*)defaultImage shouldChangeOffset:(BOOL)shouldChangeOffset {
	
	//MARK: Need to use self, since this is an added category
	self = [self initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	
	if (self) {
		[self awakeFromNib];
		
		
#ifdef imgeDefaultPinAnnotation
		if (defaultImage == nil) {
			defaultImage = imgeDefaultPinAnnotation;
		}
#endif
		
		self.image = defaultImage;
		
		if (defaultImage && shouldChangeOffset) {
			CGPoint modifiedOffset = self.centerOffset;
			modifiedOffset.y -= (defaultImage.size.height/2.0);
			[self setCenterOffset:modifiedOffset];
		}
	}
	
	return self;
}

- (void)animateCustomDropAfterDelay:(NSTimeInterval)delay fromOffset:(CGPoint)offset {
	CGRect animatedFrame = self.frame;
	
	// Move annotation out of view
	//FXDLog(@"superview.superview: %@", NSStringFromCGRect(self.superview.superview.frame));
	
	CGRect modifiedFrame = self.frame;
	modifiedFrame.origin.x += offset.x;
	modifiedFrame.origin.y += offset.y;
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
		 
		 [UIView
		  animateWithDuration:durationQuickAnimation
		  animations:^{
			  self.transform = CGAffineTransformMakeScale(1.0, 0.8);
		  }
		  completion:^(BOOL finished){
			  [UIView
			   animateWithDuration:durationQuickAnimation
			   animations:^{
				   self.transform = CGAffineTransformIdentity;
			   }];
		  }];
	 }];
}

@end
