//
//  FXDTextView.m
//
//
//  Created by petershine on 10/30/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDTextView.h"


#pragma mark - Private interface
@interface FXDTextView (Private)
@end


#pragma mark - Public implementation
@implementation FXDTextView


#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
    [super dealloc];
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
        [self configureForAllInitializers];
    }
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        [self configureForAllInitializers];
    }
	
    return self;
}

- (void)configureForAllInitializers {    
    // Primitives
    
    // Instance variables
    
    // Properties
    
    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Drawing
- (void)layoutSubviews {
	[super layoutSubviews];
	
}


#pragma mark - Private


#pragma mark - Overriding


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
		
		CGSize sizeForAssignedText = [assignedText sizeWithFont:self.font constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
		
		modifiedFrame.size.height = (sizeForAssignedText.height > self.contentSize.height) ? sizeForAssignedText.height : self.contentSize.height;
		FXDLog(@"(after)modifiedFrame: %@", NSStringFromCGRect(modifiedFrame));
				
		[self setFrame:modifiedFrame];
	}
}


@end