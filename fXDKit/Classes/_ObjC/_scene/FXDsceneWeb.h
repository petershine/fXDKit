

#import "FXDsceneScroll.h"
@interface FXDsceneWeb : FXDsceneScroll <UIWebViewDelegate> {
	NSURLRequest *_initialWebRequest;
	UIWebView *_mainWebview;
}

@property (strong, nonatomic) NSURLRequest *initialWebRequest;

@property (strong, nonatomic) NSURLRequest *startedWebRequest;
@property (strong, nonatomic) NSURLRequest *finishedWebRequest;


@property (strong, nonatomic) IBOutlet UIWebView *mainWebview;


- (IBAction)pressedNavigateBackButton:(id)sender;
- (IBAction)pressedNavigateForwardButton:(id)sender;
- (IBAction)pressedPageReloadButton:(id)sender;
- (IBAction)pressedStopLoadingButton:(id)sender;


- (void)loadWebRequestPath:(NSString*)requestPath;

@end