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

#if ForDEVELOPER
	FXDLog_DEFAULT;
	FXDLog(@"_delegateBlock: %@", _delegateBlock);
#endif

	// Instance variables
	_delegateBlock = nil;
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
	
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public
- (id)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockButtonAtIndexClicked)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... {

	self = [super initWithTitle:title
					   message:message
					  delegate:nil
			 cancelButtonTitle:cancelButtonTitle
			 otherButtonTitles:otherButtonTitles, nil];

	if (self) {
		self.delegateBlock = clickedButtonAtIndexBlock;
		
		[self setDelegate:self];
	}

	return self;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
- (void)alertView:(FXDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (alertView.delegateBlock) {
		alertView.delegateBlock(alertView, buttonIndex);
	}
}


@end

#pragma mark - Category
@implementation UIAlertView (Added)
@end
