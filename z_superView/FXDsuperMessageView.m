//
//  FXDsuperMessageView.m
//
//
//  Created by petershine on 5/30/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperMessageView.h"


#pragma mark - Public implementation
@implementation FXDsuperMessageView


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObject(_alertCallback);

	_alertCallback = nil;
}


#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions
- (IBAction)pressedCancelButton:(id)sender {
	[super pressedCancelButton:sender];
	
	if (self.alertCallback) {
		self.alertCallback(self, buttonIndexCancel);
	}
	
	FXDWindow *mainWindow = [FXDWindow mainWindow];
	[mainWindow hideMessageView];
}

- (IBAction)pressedAcceptButton:(id)sender {	FXDLog_DEFAULT;
	if (self.alertCallback) {
		self.alertCallback(self, buttonIndexAccept);
	}
	
	self.didPressAcceptButton = YES;
	
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 
		self.labelAccepting.text = NSLocalizedString(text_Accepting, nil);
	}];
	
	
	FXDWindow *mainWindow = [FXDWindow mainWindow];
	[mainWindow hideMessageView];
}

#pragma mark - Public
- (void)configureWithCancelButtonTitle:(NSString*)cancelButtonTitle withAcceptButtonTitle:(NSString*)acceptButtonTitle {
	
	if (acceptButtonTitle) {
		if (cancelButtonTitle == nil) {
			cancelButtonTitle = NSLocalizedString(text_Cancel, nil);
		}
	}
	else {
		self.buttonAccept.hidden = YES;
		
		CGPoint modifiedCenter = self.buttonCancel.center;
		modifiedCenter.x = CGRectGetMidX(self.frame);
		
		[self.buttonCancel setCenter:modifiedCenter];
		
		if (cancelButtonTitle == nil) {
			cancelButtonTitle = NSLocalizedString(text_OK, nil);
		}
	}
	
	
	[self.buttonCancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
	[self.buttonAccept setTitle:acceptButtonTitle forState:UIControlStateNormal];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
