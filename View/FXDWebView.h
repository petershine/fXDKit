

#import "FXDimportCore.h"

@import UIKit;
@import Foundation;

#define durationDefaultResponseWaiting	0.05


@class WebFrame;
@class WebView;

@interface UIWebView (JavaScriptResponding) <UIAlertViewDelegate>
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
@end
