
@import UIKit;
@import Foundation;


@interface FXDWebView : UIWebView
@property (nonatomic) BOOL didStartLoading;
@end


//NOTE:javascript alert,confirm 커스터마이징
@class WebFrame;
@class WebView;

@interface UIWebView (JavaScriptResponding)
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
@end
