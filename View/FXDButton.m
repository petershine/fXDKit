//
//  FXDButton.m
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDButton.h"


@implementation FXDButton

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (UILabel*)customTitleLabel {
	
	if (_customTitleLabel == nil) {
		_customTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
		
		_customTitleLabel.textAlignment = NSTextAlignmentCenter;
		
		_customTitleLabel.backgroundColor = [UIColor clearColor];
		_customTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		[self addSubview:_customTitleLabel];
		[self bringSubviewToFront:_customTitleLabel];
	}
	
	return _customTitleLabel;
}

- (void)setCustomTitleLabel:(UILabel *)customTitleLabel {
	[_customTitleLabel removeFromSuperview];
	_customTitleLabel = nil;
	
	_customTitleLabel = customTitleLabel;
	[self addSubview:_customTitleLabel];
	[self bringSubviewToFront:_customTitleLabel];
}


#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


@implementation UIButton (Essential)
- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets {
	
	void (^ResizeForState)(UIControlState) = ^(UIControlState state){
		UIImage *image = [self imageForState:state];
		
		if (image) {
			image = [image resizableImageWithCapInsets:capInsets];
			[self setImage:image forState:state];
		}
	};
	
	ResizeForState(UIControlStateNormal);
	ResizeForState(UIControlStateHighlighted);
	ResizeForState(UIControlStateSelected);
	ResizeForState(UIControlStateDisabled);
}

- (void)replaceBackgroundImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets {
	void (^ResizeForState)(UIControlState) = ^(UIControlState state){
		UIImage *image = [self backgroundImageForState:state];
		
		if (image) {
			image = [image resizableImageWithCapInsets:capInsets];
			[self setBackgroundImage:image forState:state];
		}
	};
	
	ResizeForState(UIControlStateNormal);
	ResizeForState(UIControlStateHighlighted);
	ResizeForState(UIControlStateSelected);
	ResizeForState(UIControlStateDisabled);
}

@end