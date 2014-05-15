//
//  FXDTextView.m
//
//
//  Created by petershine on 10/30/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDTextView.h"


#pragma mark - Public implementation
@implementation FXDTextView


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

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark -  Category
@implementation UITextView (Added)
- (BOOL)alignVerticallyAtCenterWithChangedText:(NSString*)changedText withMaximumSize:(CGSize)maximumSize {

	if (changedText == nil) {
		changedText = self.text;
	}


	if (CGSizeEqualToSize(maximumSize, CGSizeZero)) {
		maximumSize = CGSizeMake(self.frame.size.width, self.frame.size.width);
	}


	CGRect boundingRect = [self boundingRectForChangedText:changedText
											forMaximumSize:maximumSize];

	boundingRect.size.height += (self.font.pointSize*1.5);

	if (ceilf(boundingRect.size.height) > maximumSize.height) {
		//FXDLog(@"NO: %@ %@ %@", _Size(maximumSize), _Variable(self.font.pointSize), _Rect(boundingRect));
		return NO;
	}


	if (boundingRect.size.height > maximumSize.height-self.font.pointSize) {
		boundingRect.size.height = maximumSize.height;
	}


	boundingRect.origin.x = self.frame.origin.x;
	boundingRect.size.width = self.frame.size.width;

	boundingRect.origin.y = (maximumSize.height -boundingRect.size.height)/2.0;

	self.frame = boundingRect;

	//FXDLog(@"YES: %@ %@ %@", _Size(maximumSize), _Variable(self.font.pointSize), _Rect(boundingRect));

	return YES;
}

- (CGRect)boundingRectForChangedText:(NSString*)changedText forMaximumSize:(CGSize)maximumSize {
	CGRect boundingRect = [changedText
						   boundingRectWithSize:CGSizeMake(maximumSize.width, INFINITY)
						   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
						   attributes:@{NSFontAttributeName: self.font}
						   context:nil];

	return boundingRect;
}

@end