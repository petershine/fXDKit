

#import "FXDButton.h"


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