//
//  FXDsuperWebScene.h
//
//
//  Created by petershine on 2/5/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#define	userdefaultStringInitialWebURL	@"InitialWebURLstringKey"

#ifndef initialWebURLstring
	#warning //TODO: Define initialWebURLstring
	#define initialWebURLstring	@"http://www.google.com"
#endif


#import "FXDsuperScrollScene.h"

@interface FXDsuperWebScene : FXDsuperScrollScene <UIWebViewDelegate>
@property (strong, nonatomic) NSURLRequest *initialWebRequest;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIWebView *mainWebview;


#pragma mark - IBActions
- (IBAction)pressedNavigateBackButton:(id)sender;
- (IBAction)pressedNavigateForwardButton:(id)sender;
- (IBAction)pressedPageReloadButton:(id)sender;
- (IBAction)pressedStopLoadingButton:(id)sender;

#pragma mark - Public
- (void)loadWebURLstring:(NSString*)webURLstring;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end