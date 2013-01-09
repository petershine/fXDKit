//
//  FXDAlertView.m
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAlertView.h"


#pragma mark - Public implementation
@implementation FXDAlertView


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	if (_delegateBlock) {
		_delegateBlock = nil;
	}
}


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
- (id)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockButtonAtIndexClicked)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... {

	self = [self initWithTitle:title
					   message:message
					  delegate:nil
			 cancelButtonTitle:cancelButtonTitle
			 otherButtonTitles:otherButtonTitles, nil];

	if (self) {
		[self setDelegate:self];

		_delegateBlock = clickedButtonAtIndexBlock;
	}

	return self;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (_delegateBlock) {
		_delegateBlock(self, buttonIndex);
	}
	else {
		FXDLog(@"%@", @"ASSIGN delegeBlock");
	}
}


@end

#pragma mark - Category
@implementation UIAlertView (Added)
@end
