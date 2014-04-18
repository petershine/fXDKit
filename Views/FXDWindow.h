//
//  FXDWindow.h
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#ifndef classnameProgressView
	#define classnameProgressView	@"FXDsuperProgressView"
#endif

#ifndef classnameMessageView
	#define classnameMessageView	@"FXDsuperMessageView"
#endif


#import "FXDsuperProgressView.h"
#import "FXDsuperMessageView.h"


@class FXDsuperLaunchScene;


@interface FXDWindow : UIWindow

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDsuperProgressView *progressView;
@property (strong, nonatomic) IBOutlet FXDsuperMessageView *messageView;


#pragma mark - IBActions

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIWindow (Added)
+ (instancetype)instantiateDefaultWindow;
+ (instancetype)applicationWindow;

- (void)prepareWindowWithLaunchScene:(FXDsuperLaunchScene*)launchScene;
- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback;

@end

@interface UIWindow (Progress)
+ (void)showProgressViewAfterDelay:(NSTimeInterval)delay;
+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay;

- (void)showDefaultProgressView;
- (void)showProgressViewWithNibName:(NSString*)nibName;

- (void)hideProgressView;

@end

@interface UIWindow (Message)
- (void)showMessageViewWithNibName:(NSString*)nibName withTitle:(NSString*)title message:(NSString*)message  cancelButtonTitle:(NSString*)cancelButtonTitle acceptButtonTitle:(NSString*)acceptButtonTitle  clickedButtonAtIndexBlock:(FXDcallbackAlert)clickedButtonAtIndexBlock;

- (void)hideMessageView;

@end

