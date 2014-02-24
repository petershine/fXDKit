//
//  FXDsuperWebScene.m
//
//
//  Created by petershine on 2/5/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


#import "FXDsuperWebScene.h"


#pragma mark - Public implementation
@implementation FXDsuperWebScene


#pragma mark - Memory management
- (void)dealloc {
	[_mainWebview setDelegate:nil];
}


#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	//MARK: Assume keyboard dismissal is default for WebView
	if (SYSTEM_VERSION_lowerThan(iosVersion7)) {

	}
	else {
		self.mainWebview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
	}
}

#pragma mark - StatusBar

#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding
- (UIScrollView*)mainScrollview {
	if (_mainScrollview == nil) {
		_mainScrollview = self.mainWebview.scrollView;
	}

	return _mainScrollview;
}


#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {
	if (parent == nil) {
		[self.mainWebview stopLoading];
	}

	[super willMoveToParentViewController:parent];
}


#pragma mark - Segues

#pragma mark - IBActions
- (IBAction)pressedNavigateBackButton:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"mainWebview.canGoBack: %d", self.mainWebview.canGoBack);
	[self.mainWebview goBack];
}

- (IBAction)pressedNavigateForwardButton:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"mainWebview.canGoForward: %d", self.mainWebview.canGoForward);
	[self.mainWebview goForward];
}

- (IBAction)pressedPageReloadButton:(id)sender {	FXDLog_DEFAULT;
	[self.mainWebview reload];
}

- (IBAction)pressedStopLoadingButton:(id)sender {	FXDLog_DEFAULT;
	[self.mainWebview stopLoading];
}

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	FXDLog_DEFAULT;

	FXDLog(@"navigationType: %ld", (long)navigationType);
	FXDLog(@"request: %@", request);
	FXDLog(@"allHTTPHeaderFields: %@", [request allHTTPHeaderFields]);

	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {	FXDLog_DEFAULT;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {	FXDLog_DEFAULT;
	NSString *source = [webView stringByEvaluatingJavaScriptFromString:
						@"document.getElementsByTagName('html')[0].outerHTML"];

	FXDLog(@"source: %@", source);

	NSCachedURLResponse *webviewResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
	FXDLog(@"webviewResponse allHeaderFields: %@",[(NSHTTPURLResponse*)webviewResponse.response allHeaderFields]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {	FXDLog_DEFAULT;
	FXDLog_ERROR;

	if (error && [error code] != -999) {
		//TODO:
	}
}

@end