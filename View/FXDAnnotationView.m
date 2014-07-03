

#import "FXDAnnotationView.h"


@implementation MKAnnotationView (Essential)
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDefaultImage:(UIImage*)defaultImage shouldChangeOffset:(BOOL)shouldChangeOffset {
	
	//MARK: Need to use self, since this is an added category
	self = [self initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	
	if (self) {
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
