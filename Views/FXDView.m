//
//  FXDView.m
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDView.h"


#pragma mark - Public implementation
@implementation FXDView


#pragma mark - Memory management


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {	//FXDLog_DEFAULT;
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
	}
	
    return self;
}

- (void)awakeFromNib {	//FXDLog_DEFAULT;
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIView (Added)
+ (id)viewFromNibName:(NSString*)nibName {
	id view = [self viewFromNibName:nibName withOwner:nil];
	
	return view;
}

+ (id)viewFromNib:(UINib*)nib {
	
	id view = [self viewFromNib:nib withOwner:nil];
	
	return view;
}

+ (id)viewFromNibName:(NSString*)nibName withOwner:(id)ownerOrNil {
	if (nibName == nil) {
		nibName = NSStringFromClass([self class]);
	}

	UINib *nib = [UINib nibWithNibName:nibName bundle:nil];

	id view = [self viewFromNib:nib withOwner:ownerOrNil];

	return view;
}

+ (id)viewFromNib:(UINib*)nib withOwner:(id)ownerOrNil {
	if (nib == nil) {
		NSString *nibName = NSStringFromClass([self class]);

		nib = [UINib nibWithNibName:nibName bundle:nil];
	}

	id view = nil;

	NSArray *viewArray = [nib instantiateWithOwner:ownerOrNil options:nil];

	if (viewArray) {
		for (id subview in viewArray) {	//Assumes there is only one root object

			if ([[self class] isSubclassOfClass:[subview class]]) {
				view = subview;
				break;
			}
		}
	}

#if DEBUG
	if (view == nil) {
		FXDLog_DEFAULT;
		FXDLog(@"self class: %@ viewArray:\n%@", [self class], viewArray);
	}
#endif


	return view;
}

- (void)applyDefaultBorderLine {
	[self applyDefaultBorderLineWithCornerRadius:radiusCorner];
}

- (void)applyDefaultBorderLineWithCornerRadius:(CGFloat)radius {
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = radius;
	
	self.layer.borderWidth = 1.0;
	self.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)reframeToBeAtTheCenterOfSuperview {	FXDLog_DEFAULT;
	
	if (self.superview) {
		CGRect modifiedFrame = self.frame;
		modifiedFrame.origin.x = (self.superview.frame.size.width -modifiedFrame.size.width)/2.0;
		modifiedFrame.origin.y = (self.superview.frame.size.height -modifiedFrame.size.height)/2.0;
		
		[self setFrame:modifiedFrame];
	}
}

- (void)fadeIn {
	self.alpha = 0.0;
	
	[UIView animateWithDuration:durationAnimation
					 animations:^{
						 self.alpha = 1.0;
					 }];
}

- (void)fadeOut {
	[UIView animateWithDuration:durationAnimation
					 animations:^{
						 self.alpha = 0.0;
					 }];
}

- (void)fadeInFromHidden {
	self.alpha = 0.0;
	
	if (self.hidden) {
		self.hidden = NO;
	}
	
	[UIView animateWithDuration:durationQuickAnimation
						  delay:0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 self.alpha = 1.0;
					 }
					 completion:^(BOOL finished) {
						 //
					 }];
}

- (void)fadeOutThenHidden {
	[UIView animateWithDuration:durationQuickAnimation
						  delay:0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 self.alpha = 0.0;
					 }
					 completion:^(BOOL finished) {						 
						 if (self.hidden == NO) {
							 self.hidden = YES;
						 }
						 
						 self.alpha = 1.0;
					 }];
}

- (void)addAsFadeInSubview:(UIView*)subview {	//FXDLog_DEFAULT;
	subview.alpha = 0.0;
	
	[self addSubview:subview];
	[self bringSubviewToFront:subview];
	
	[subview fadeIn];
}

- (void)removeAsFadeOutSubview:(UIView*)subview afterRemoved:(void(^)(void))afterRemoved {	//FXDLog_DEFAULT;

	[UIView animateWithDuration:durationAnimation
					 animations:^{
						 subview.alpha = 0.0;
					 }
					 completion:^(BOOL finished) {						 
						 [subview removeFromSuperview];
						 
						 if (afterRemoved) {
							 afterRemoved();
						 }
					 }];
}

- (UIImage*)renderedImageFromView:(UIView*)view {

	UIImage *image = [self renderedImageFromView:view forScale:[[UIScreen mainScreen] scale]];

    return image;
}

- (UIImage*)renderedImageFromView:(UIView*)view forScale:(CGFloat)scale {
	if (view == nil) {
		view = self;
	}


	UIImage *image = nil;

	UIGraphicsBeginImageContextWithOptions(view.bounds.size,
										   view.opaque,
										   scale);
	{
		[view.layer renderInContext:UIGraphicsGetCurrentContext()];
		image = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();

	FXDLog_DEFAULT;
	FXDLog(@"image.size: %@", NSStringFromCGSize(image.size));

    return image;
}

- (id)parentViewOfClassName:(NSString*)className {
	id parentView = nil;

	if (self.superview) {
		if ([self.superview isKindOfClass:NSClassFromString(className)]) {
			parentView = self.superview;
		}
		else {
			parentView = [self.superview parentViewOfClassName:className];
		}
	}

	return parentView;

}

@end