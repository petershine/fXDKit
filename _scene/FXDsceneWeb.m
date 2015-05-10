

#import "FXDsceneWeb.h"


@implementation FXDsceneWeb

#pragma mark - Memory management
- (void)dealloc {
	[_mainWebview stopLoading];
	_mainWebview.delegate = nil;
}

#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	self.mainWebview.scalesPageToFit = YES;
}

#pragma mark - StatusBar

#pragma mark - Autorotating

#pragma mark - View Appearing
- (void)willMoveToParentViewController:(UIViewController *)parent {

	if (parent == nil) {
		[self.mainWebview stopLoading];
		self.mainWebview.delegate = nil;
	}

	[super willMoveToParentViewController:parent];
}


#pragma mark - Property overriding
- (UIScrollView*)mainScrollview {
	if (_mainScrollview == nil) {

		if (self.mainWebview) {
			_mainScrollview = self.mainWebview.scrollView;
		}
		else {
			_mainScrollview = [super mainScrollview];
		}
	}

	return _mainScrollview;
}

#pragma mark - Method overriding

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
- (void)loadWebRequestPath:(NSString*)requestPath {	FXDLog_DEFAULT;

	NSURL *requestURL = [NSURL evaluatedURLforPath:requestPath];

	FXDLogBOOL(self.mainWebview.isLoading);
	FXDLogBOOL(self.mainWebview.loading);

	NSURLRequest *webRequest = [[NSURLRequest alloc]
								initWithURL:requestURL
								cachePolicy:NSURLRequestUseProtocolCachePolicy
								timeoutInterval:(intervalOneSecond*60.0)];

	[self.mainWebview loadRequest:webRequest];
}


#pragma mark - Observer

#pragma mark - Delegate
//NOTE: UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	FXDLog_DEFAULT;
	FXDLogObject(webView.request.URL);

	FXDLogVariable(navigationType);
	FXDLog(@"%@ %@", _Object(request.URL.scheme), _Object(request.URL.baseURL));

	FXDLogVariable(request.cachePolicy);
	FXDLogVariable(request.timeoutInterval);
	FXDLogBOOL(request.HTTPShouldHandleCookies);
	FXDLogBOOL(request.HTTPShouldUsePipelining);
	FXDLogObject(request.allHTTPHeaderFields);

	return YES;
}

#pragma mark -
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {	FXDLog_DEFAULT;
	FXDLogObject(webView.request.URL);
	FXDLog_ERROR;

	if (error && [error code] != -999) {
		//TODO:
	}
}

- (void)webViewDidStartLoad:(UIWebView *)webView {	FXDLog_DEFAULT;
	FXDLogObject(webView.request.URL);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {	FXDLog_DEFAULT;
	FXDLogObject(webView.request.URL);

	FXDLogBOOL(webView.canGoBack);
	FXDLogBOOL(webView.canGoForward);

#if ForDEVELOPER
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request].response;
	FXDLogObject(httpResponse.allHeaderFields);
#endif
}

@end