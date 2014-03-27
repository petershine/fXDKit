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
- (void)modifyHeightForAssignedText:(NSString*)assignedText {
	if (assignedText == nil) {
		assignedText = self.text;
	}
	
	if (assignedText) {	FXDLog_DEFAULT;
		FXDLogObject(assignedText);
		
		CGRect modifiedFrame = self.frame;
		FXDLog(@"(before) %@", _Struct(modifiedFrame));
		
		CGSize maximumSize = CGSizeMake(modifiedFrame.size.width, 100000000.0);
		
		CGSize sizeForAssignedText = CGSizeZero;

		sizeForAssignedText = [assignedText boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
		
		modifiedFrame.size.height = (sizeForAssignedText.height > self.contentSize.height) ? sizeForAssignedText.height : self.contentSize.height;
		FXDLog(@"(after) %@", _Struct(modifiedFrame));
				
		[self setFrame:modifiedFrame];
	}
}

@end