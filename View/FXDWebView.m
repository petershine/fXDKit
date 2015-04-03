

#import "FXDWebView.h"

#import "FXDimportCore.h"


//NOTE: For javascript alert,confirm
@implementation UIWebView (JavaScriptResponding)

NSInteger diagStat = 3;

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)webFrame {	FXDLog_DEFAULT;
	FXDLogObject(message);
	FXDLogObject(webFrame);

	UIAlertView* customAlert = [[UIAlertView alloc]
								initWithTitle:nil
								message:message
								delegate:nil
								cancelButtonTitle:@"확인"
								otherButtonTitles:nil];
	[customAlert show];
}

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)webFrame {	FXDLog_DEFAULT;
	FXDLogObject(message);
	FXDLogObject(webFrame);

	UIAlertView *confirmDiag = [[UIAlertView alloc]
								initWithTitle:nil
								message:message
								delegate:self
								cancelButtonTitle:@"예"
								otherButtonTitles:@"아니오", nil];
	[confirmDiag show];

	while (diagStat == 3) {
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
	}


	FXDLogVariable(diagStat);

	if (diagStat == 0){
		return YES;
	}
	else{
		return NO;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{	FXDLog_DEFAULT;
	diagStat = buttonIndex;
	FXDLogVariable(diagStat);
}

@end
