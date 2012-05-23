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
- (void)layoutSubviews {	FXDLog_DEFAULT;
	[super layoutSubviews];
	
}

- (void)drawRect:(CGRect)rect {	FXDLog_DEFAULT;
	[super drawRect:rect];
	
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIView (Added)
+ (id)viewFromDefaultNib {	
	NSString *nibName = NSStringFromClass([self class]);
	
	id view = [self viewFromNibName:nibName];
	
	return view;
}

+ (id)viewFromNibName:(NSString*)nibName {
	if (nibName == nil) {
		nibName = NSStringFromClass([self class]);
	}
	
	id view = nil;
	
	UINib *defaultNib = [UINib nibWithNibName:nibName bundle:nil];
	
	NSArray *viewArray = [defaultNib instantiateWithOwner:nil options:nil];
	
	if (viewArray) {	
		for (id subview in viewArray) {	//Assumes there is only one root object
			
			if ([NSStringFromClass([subview class]) isEqualToString:nibName]) {
				view = subview;
			}
			else {	FXDLog_DEFAULT;
				FXDLog(@"subview class: %@", [subview class]);
			}
		}
	}
	
	return view;
}

+ (id)viewFromNibName:(NSString*)nibName forModifiedSize:(CGSize)modifiedSize {
	id view = [self viewFromNibName:nibName];
	
	CGRect modifiedFrame = [(UIView*)view frame];
	modifiedFrame.size = modifiedSize;
	[(UIView*)view setFrame:modifiedFrame];
	
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


@end