

#ifndef	TEST_shouldEvaluateSource
	#define	TEST_shouldEvaluateSource	FALSE
#endif


#import "FXDWebView.h"

#import "FXDsceneScroll.h"
@interface FXDsceneWeb : FXDsceneScroll <UIWebViewDelegate> {
	FXDWebView *_mainWebview;
}

@property (strong, nonatomic) NSURLRequest *initialWebRequest;

@property (strong, nonatomic) NSURLRequest *startedWebRequest;
@property (strong, nonatomic) NSURLRequest *finishedWebRequest;

@property (strong, nonatomic) IBOutlet FXDWebView *mainWebview;


- (IBAction)pressedNavigateBackButton:(id)sender;
- (IBAction)pressedNavigateForwardButton:(id)sender;
- (IBAction)pressedPageReloadButton:(id)sender;
- (IBAction)pressedStopLoadingButton:(id)sender;


- (void)loadWebRequestURL:(NSString*)requestURL;

@end
