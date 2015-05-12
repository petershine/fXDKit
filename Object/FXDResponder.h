

@import UIKit;
@import Foundation;


@interface FXDResponder : UIResponder <UIApplicationDelegate>

//NOTE: To prevent app being affected when state is being changed during launching
@property (nonatomic) BOOL isAppLaunching;
@property (nonatomic) BOOL didFinishLaunching;

@property (strong, nonatomic) UIWindow *window;

@end


@interface UIResponder (Added) <UIApplicationDelegate>
- (void)executeOperationsForApplication:(UIApplication*)application withLaunchOption:(NSDictionary*)launchOptions;
- (BOOL)isUsableLaunchOption:(NSDictionary*)launchOptions;

@end
