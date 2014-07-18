

#import "FXDActionSheet.h"


@implementation FXDActionSheet

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObject(_alertCallback);
	_alertCallback = nil;
}

#pragma mark - Initialization

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
		self.delegate = self;
		self.alertCallback = alertCallback;
	}
	
	return self;
}

#pragma mark - Observer

#pragma mark - Delegate
- (void)actionSheet:(FXDActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet.alertCallback) {
		actionSheet.alertCallback(actionSheet, buttonIndex);
	}
}

@end
