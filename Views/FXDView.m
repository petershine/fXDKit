//
//  FXDView.m
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDView.h"


#pragma mark - Private interface
@interface FXDView (Private)
@end


#pragma mark - Public implementation
@implementation FXDView


#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
    FXDLog_DEFAULT;[super dealloc];
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {	FXDLog_DEFAULT;
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		//awakeFromNib
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {	FXDLog_DEFAULT;
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
	}
	
    return self;
}

- (void)awakeFromNib {	FXDLog_DEFAULT;
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding
#if ForDEVELOPER
- (void)layoutSubviews {
	FXDLog(@" ");FXDLog(@"OVERRIDE: %@ : %@", strClassSelector, NSStringFromCGRect(self.frame));
	
	// Implement or Erase
	
}

- (void)drawRect:(CGRect)rect {
	FXDLog(@" ");FXDLog(@"OVERRIDE: %@ : %@", strClassSelector, NSStringFromCGRect(self.frame));
	
	// Implement or Erase
}
#endif


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIView (Added)
+ (id)viewFromNibName:(NSString*)nibName {
	if (nibName == nil) {
		nibName = NSStringFromClass([self class]);
	}
	
	id view = nil;
	
	UINib *defaultNib = [UINib nibWithNibName:nibName bundle:nil];
	
	NSArray *viewArray = [defaultNib instantiateWithOwner:nil options:nil];
	
	if (viewArray) {	
		for (id subview in viewArray) {	//Assumes there is only one root object
			
			if ([[self class] isSubclassOfClass:[subview class]]) {
				view = subview;
				break;
			}
			else {	FXDLog_DEFAULT;
				FXDLog(@"self class: %@ subview class: %@", [self class], [subview class]);
			}
		}
	}
	
	return view;
}

+ (id)viewFromNibName:(NSString*)nibName forModifiedFrame:(CGRect)modifiedFrame {
	id view = [self viewFromNibName:nibName];
	
	[(UIView*)view setFrame:modifiedFrame];
	
	return view;
}

#pragma mark -
- (void)applyDefaultBorderLine {
	[self applyDefaultBorderLineWithCornerRadius:radiusCorner];
}

- (void)applyDefaultBorderLineWithCornerRadius:(CGFloat)radius {
	self.layer.borderColor = [UIColor darkGrayColor].CGColor;
	self.layer.borderWidth = 1.0;
	self.layer.cornerRadius = radius;
	self.clipsToBounds = YES;
}

- (void)reframeToBeAtTheCenterOfSuperview {	FXDLog_DEFAULT;
	
	if (self.superview) {
		CGRect modifiedFrame = self.frame;
		modifiedFrame.origin.x = (self.superview.frame.size.width -modifiedFrame.size.width)/2.0;
		modifiedFrame.origin.y = (self.superview.frame.size.height -modifiedFrame.size.height)/2.0;
		
		[self setFrame:modifiedFrame];
	}
}

#pragma mark -
- (void)fadeInSubview:(UIView*)subview {	FXDLog_DEFAULT;
	subview.alpha = 0.0;
	
	[self addSubview:subview];
	[self bringSubviewToFront:subview];
	
	[UIView animateWithDuration:durationAnimation
					 animations:^{
						 subview.alpha = 1.0;
					 }];
}

- (void)fadeOutSubview:(UIView*)subview {	FXDLog_DEFAULT;
	[UIView animateWithDuration:durationAnimation
					 animations:^{
						 subview.alpha = 0.0;
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 [subview removeFromSuperview];
						 }
					 }];
}


@end