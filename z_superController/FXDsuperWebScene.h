//
//  FXDsuperWebScene.h
//
//
//  Created by petershine on 2/5/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#define userdefaultStringInitialWebURL	@"InitialWebURLStringKey"

#ifndef initialWebURLstring
	#define initialWebURLstring	@"http://www.google.com"
#endif


#import "FXDsuperScrollController.h"

@interface FXDsuperWebScene : FXDsuperScrollController <UIWebViewDelegate>
// Properties
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
