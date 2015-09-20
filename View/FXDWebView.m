

#import "FXDWebView.h"


@implementation UIWebView (JavaScriptResponding)


static BOOL _userConfirmedResponse = NO;
static BOOL _shouldWaitForAlert = NO;


- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)webFrame {	FXDLog_DEFAULT;
	FXDLogObject(message);
	FXDLogObject(webFrame);

	_userConfirmedResponse = NO;
	_shouldWaitForAlert = YES;


	UIAlertView *webAlert = [[UIAlertView alloc]
							 initWithTitle:nil
							 message:message
							 delegate:self
							 cancelButtonTitle:nil
							 otherButtonTitles:NSLocalizedString(@"확인", nil), nil];
	[webAlert show];


	while (_shouldWaitForAlert) {
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:durationDefaultResponseWaiting]];
	}

	FXDLogBOOL(_shouldWaitForAlert);
	FXDLogObject(@"ALERT CLOSED");

}

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)webFrame {	FXDLog_DEFAULT;
	FXDLogObject(message);
	FXDLogObject(webFrame);

	_userConfirmedResponse = NO;
	_shouldWaitForAlert = YES;


	UIAlertView *webConfirm = [[UIAlertView alloc]
							   initWithTitle:nil
							   message:message
							   delegate:self
							   cancelButtonTitle:NSLocalizedString(@"아니오", nil)
							   otherButtonTitles:NSLocalizedString(@"예", nil), nil];
	[webConfirm show];


	while (_shouldWaitForAlert) {
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:durationDefaultResponseWaiting]];
	}


	FXDLogBOOL(_userConfirmedResponse);
	FXDLogBOOL(_shouldWaitForAlert);
	FXDLogObject(@"ALERT CLOSED");


	return _userConfirmedResponse;
}

//MARK: UIAlertViewDelegate
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	FXDLogVariable(buttonIndex);
	FXDLogBOOL(buttonIndex == alertView.cancelButtonIndex);

	if (buttonIndex == alertView.cancelButtonIndex){
		_userConfirmedResponse = NO;
	}
	else {
		_userConfirmedResponse = YES;
	}

	_shouldWaitForAlert = NO;
}

@end
