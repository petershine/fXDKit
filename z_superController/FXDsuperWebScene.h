//
//  FXDsuperWebScene.h
//
//
//  Created by petershine on 2/5/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


#import "FXDsuperScrollController.h"

@interface FXDsuperWebScene : FXDsuperScrollController <UIWebViewDelegate>
// Properties
@property (strong, nonatomic) NSURLRequest *webRequest;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIWebView *mainWebview;


#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
