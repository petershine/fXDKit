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
	FXDLog(@"_callbackBlock: %@", _callbackBlock);
	_callbackBlock = nil;
#endif
	
	FXDLog_DEFAULT;
}


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
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
- (id)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDcallbackBlockForAlert)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... {

	self = [super initWithTitle:title
					   message:message
					  delegate:nil
			 cancelButtonTitle:cancelButtonTitle
			 otherButtonTitles:otherButtonTitles, nil];

	if (self) {
		self.callbackBlock = clickedButtonAtIndexBlock;
		
		[self setDelegate:self];
	}

	return self;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
- (void)alertView:(FXDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (alertView.callbackBlock) {
		alertView.callbackBlock(alertView, buttonIndex);
	}
}

@end


#pragma mark - Category
@implementation UIAlertView (Added)
@end
