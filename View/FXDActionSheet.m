//
//  FXDActionSheet.m
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDActionSheet.h"


@implementation FXDActionSheet

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObject(_alertCallback);
	_alertCallback = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedUIApplicationDidEnterBackground:)
	 name:UIApplicationDidEnterBackgroundNotification
	 object:nil];
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public
- (instancetype)initWithTitle:(NSString *)title withButtonTitleArray:(NSArray*)buttonTitleArray cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback {	FXDLog_DEFAULT;
	
	self = [super initWithTitle:title
					   delegate:nil
			  cancelButtonTitle:cancelButtonTitle
		 destructiveButtonTitle:destructiveButtonTitle
			  otherButtonTitles:nil];
	
	if (self) {
		self.alertCallback = alertCallback;
		[self setDelegate:self];
	}
	
	return self;
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {	FXDLog_DEFAULT;
	if (self.alertCallback) {
		self.alertCallback(self, self.cancelButtonIndex);
	}
	
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}

//MARK: - Delegate implementation
- (void)actionSheet:(FXDActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet.alertCallback) {
		actionSheet.alertCallback(actionSheet, buttonIndex);
	}
}

@end
