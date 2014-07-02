//
//  FXDAlertView.m
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAlertView.h"



@implementation FXDAlertView


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObject(_alertCallback);
	_alertCallback = nil;
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
+ (instancetype)showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback {

	__block FXDAlertView *alertView = nil;

	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 alertView = [[[self class] alloc]
					  initWithTitle:title
					  message:message
					  cancelButtonTitle:cancelButtonTitle
					  withAlertCallback:alertCallback];

		 [alertView show];
	 }];

	return alertView;
}

#pragma mark -
- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback {

	//MARK: Assume this is the condition for simple alerting withour choice
	if (cancelButtonTitle == nil) {
		cancelButtonTitle = NSLocalizedString(@"OK", nil);
	}

	self = [super
			initWithTitle:title
			message:message
			delegate:nil
			cancelButtonTitle:cancelButtonTitle
			otherButtonTitles:nil];

	if (self) {
		self.alertCallback = alertCallback;
		[self setDelegate:self];
	}

	return self;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
- (void)alertView:(FXDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (alertView.alertCallback) {
		alertView.alertCallback(alertView, buttonIndex);
	}
}

@end


#pragma mark - Category
@implementation UIAlertView (Essential)
@end
