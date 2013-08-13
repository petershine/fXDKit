//
//  FXDButton.m
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDButton.h"


#pragma mark - Public implementation
@implementation FXDButton


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

#pragma mark - Public
- (void)customizeWithTitle:(NSString*)title {
	if (self.labelCustom == nil) {
		self.labelCustom = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
		
		self.labelCustom.textAlignment = NSTextAlignmentCenter;
		
		self.labelCustom.backgroundColor = [UIColor clearColor];
		self.labelCustom.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		[self addSubview:self.labelCustom];
	}
	
	self.labelCustom.text = title;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


@implementation UIButton (Added)
- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets {
	
	void (^ResizeForState)(UIControlState state) = ^(UIControlState state){
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

@end