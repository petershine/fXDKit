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

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	FXDLog_DEFAULT;

	FXDLog(@"request: %@", request);
	FXDLog(@"navigationType: %ld", (long)navigationType);

	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {	FXDLog_DEFAULT;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {	FXDLog_DEFAULT;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {	FXDLog_DEFAULT;
	FXDLog_ERROR;

	if (error && [error code] != -999) {
		//TODO:
	}
}

@end