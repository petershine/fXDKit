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
	[_mainWebview stopLoading];
	[_mainWebview setDelegate:nil];
}


#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	self.mainWebview.scalesPageToFit = YES;
}

#pragma mark - StatusBar

#pragma mark - Autorotating

#pragma mark - View Appearing
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	NSString *webURL = [[NSUserDefaults standardUserDefaults] stringForKey:userdefaultStringInitialWebURL];

	if ([webURL length] == 0) {
		webURL = initialWebURLstring;

		[[NSUserDefaults standardUserDefaults] setObject:webURL forKey:userdefaultIntegerAppLaunchCount];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

	[self loadWebURLstring:webURL];
}

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
	FXDLogBOOL(self.mainWebview.canGoBack);
	[self.mainWebview goBack];
}

- (IBAction)pressedNavigateForwardButton:(id)sender {	FXDLog_DEFAULT;
	FXDLogBOOL(self.mainWebview.canGoForward);
	[self.mainWebview goForward];
}

- (IBAction)pressedPageReloadButton:(id)sender {	FXDLog_DEFAULT;
	[self.mainWebview stopLoading];

	[self.mainWebview reload];
}

- (IBAction)pressedStopLoadingButton:(id)sender {	FXDLog_DEFAULT;
	[self.mainWebview stopLoading];
}

#pragma mark - Public
- (void)loadWebURLstring:(NSString*)webURLstring {	FXDLog_DEFAULT;

	BOOL isValid = [NSURL validateWebURLstringOrModifyURLstring:&webURLstring];

	if (isValid == NO) {
		return;
	}


	FXDLogBOOL(self.mainWebview.isLoading);

	if (self.mainWebview.isLoading) {
		return;
	}


	[[NSUserDefaults standardUserDefaults] setObject:webURLstring forKey:userdefaultStringInitialWebURL];
	[[NSUserDefaults standardUserDefaults] synchronize];

	self.initialWebRequest = [[NSURLRequest alloc]
							  initWithURL:[NSURL URLWithString:webURLstring]
							  cachePolicy:NSURLRequestUseProtocolCachePolicy
							  timeoutInterval:(intervalOneSecond*60.0)];

	[self.mainWebview loadRequest:self.initialWebRequest];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	FXDLog_DEFAULT;

	FXDLogVariable(navigationType);
	FXDLogObject(request);
	FXDLogObject([request allHTTPHeaderFields]);

	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {	FXDLog_DEFAULT;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {	FXDLog_DEFAULT;
#if ForDEVELOPER
	NSString *source = [webView stringByEvaluatingJavaScriptFromString:
						@"document.getElementsByTagName('html')[0].outerHTML"];

	FXDLogObject(source);

	NSCachedURLResponse *webviewResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
	FXDLogObject([(NSHTTPURLResponse*)webviewResponse.response allHeaderFields]);
#endif
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {	FXDLog_DEFAULT;
	FXDLog_ERROR;

	if (error && [error code] != -999) {
		//TODO:
	}
}

@end