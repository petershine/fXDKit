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
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        [self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
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
		FXDLog(@"assignedText: %@", assignedText);
		
		CGRect modifiedFrame = self.frame;
		FXDLog(@"(before)modifiedFrame: %@", NSStringFromCGRect(modifiedFrame));
		
		CGSize maximumSize = CGSizeMake(modifiedFrame.size.width, 100000000.0);
		
#if ENVIRONMENT_newestSDK
		CGSize sizeForAssignedText = [assignedText sizeWithFont:self.font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
#else
		CGSize sizeForAssignedText = [assignedText sizeWithFont:self.font constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
#endif
		
		modifiedFrame.size.height = (sizeForAssignedText.height > self.contentSize.height) ? sizeForAssignedText.height : self.contentSize.height;
		FXDLog(@"(after)modifiedFrame: %@", NSStringFromCGRect(modifiedFrame));
				
		[self setFrame:modifiedFrame];
	}
}


@end