//
//  FXDsuperMessageView.m
//
//
//  Created by petershine on 5/30/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperMessageView.h"


#pragma mark - Public implementation
@implementation FXDsuperMessageView


#pragma mark - Memory management
- (void)dealloc {
#if ForDEVELOPER
	FXDLog(@"_callbackBlock: %@", _callbackBlock);
#endif
	
	_callbackBlock = nil;
	
	FXDLog_DEFAULT;
}


#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions
- (IBAction)pressedCancelButton:(id)sender {
	[super pressedCancelButton:sender];
	
	if (self.callbackBlock) {
		self.callbackBlock(self, buttonIndexCancel);
	}
	
	FXDWindow *applicationWindow = [FXDWindow applicationWindow];
	[applicationWindow hideMessageView];
}

- (IBAction)pressedAcceptButton:(id)sender {	FXDLog_DEFAULT;
	if (self.callbackBlock) {
		self.callbackBlock(self, buttonIndexAccept);
	}
	
	self.didPressAcceptButton = YES;
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		self.labelAccepting.text = NSLocalizedString(text_Accepting, nil);
	}];
	
	
	FXDWindow *applicationWindow = [FXDWindow applicationWindow];
	[applicationWindow hideMessageView];
}

#pragma mark - Public
- (void)configureWithCancelButtonTitle:(NSString*)cancelButtonTitle withAcceptButtonTitle:(NSString*)acceptButtonTitle {
	
	if (acceptButtonTitle) {
		if (!cancelButtonTitle) {
			cancelButtonTitle = NSLocalizedString(text_Cancel, nil);
		}
	}
	else {
		self.buttonAccept.hidden = YES;
		
		CGPoint modifiedCenter = self.buttonCancel.center;
		modifiedCenter.x = CGRectGetMidX(self.frame);
		
		[self.buttonCancel setCenter:modifiedCenter];
		
		if (!cancelButtonTitle) {
			cancelButtonTitle = NSLocalizedString(text_OK, nil);
		}
	}
	
	
	[self.buttonCancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
	[self.buttonAccept setTitle:acceptButtonTitle forState:UIControlStateNormal];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
