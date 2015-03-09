

#ifndef	TEST_shouldEvaluateSource
	#define	TEST_shouldEvaluateSource	FALSE
#endif



#import "FXDsceneScroll.h"
@interface FXDsceneWeb : FXDsceneScroll <UIWebViewDelegate>
@property (strong, nonatomic) NSURLRequest *initialWebRequest;

@property (strong, nonatomic) IBOutlet UIWebView *mainWebview;


- (IBAction)pressedNavigateBackButton:(id)sender;
- (IBAction)pressedNavigateForwardButton:(id)sender;
- (IBAction)pressedPageReloadButton:(id)sender;
- (IBAction)pressedStopLoadingButton:(id)sender;


- (void)loadWebURLstring:(NSString*)webURLstring;

@end
