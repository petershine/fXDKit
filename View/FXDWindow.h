//
//  FXDWindow.h
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

@class FXDviewInformation;

@class FXDsceneLaunching;


@interface FXDWindow : UIWindow
// IBOutlets
@property (strong, nonatomic) IBOutlet FXDviewInformation *informationView;

#pragma mark - IBActions

#pragma mark - Public
- (void)prepareWindowWithLaunchScene:(FXDsceneLaunching*)launchScene;
- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)showProgressViewAfterDelay:(NSTimeInterval)delay;
- (void)hideProgressViewAfterDelay:(NSTimeInterval)delay;

- (void)showProgressViewWithNibName:(NSString*)nibName;
- (void)hideProgressView;


#pragma mark - Observer
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification;

#pragma mark - Delegate

@end


#pragma mark - Category
@interface UIWindow (Essential)
+ (instancetype)instantiateNewWindow;

@end
