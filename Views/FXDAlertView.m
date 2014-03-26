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
- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObj(_callbackBlock);

	_callbackBlock = nil;
}


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
+ (instancetype)showAlertWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockAlertCallback)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle {

	__block FXDAlertView *alertView = nil;

	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 alertView =
		 [[FXDAlertView alloc]
		  initWithTitle:title
		  message:message
		  clickedButtonAtIndexBlock:clickedButtonAtIndexBlock
		  cancelButtonTitle:cancelButtonTitle];

		 [alertView show];
	 }];

	return alertView;
}

#pragma mark -
- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockAlertCallback)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle {
	
	if (cancelButtonTitle == nil) {
		cancelButtonTitle = NSLocalizedString(text_OK, nil);
	}

	self = [super initWithTitle:title
					   message:message
					  delegate:nil
			 cancelButtonTitle:cancelButtonTitle
			 otherButtonTitles:nil];

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
