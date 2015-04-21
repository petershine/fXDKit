
@import UIKit;
@import Foundation;

#import "FXDimportCore.h"


@class FXDsceneLaunching;


@interface FXDsubviewInformation : UIView
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorActivity;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage_0;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage_1;
@property (strong, nonatomic) IBOutlet UISlider *sliderProgress;
@property (strong, nonatomic) IBOutlet UIProgressView *indicatorProgress;
@end


@interface FXDWindow : UIWindow

@property (strong, nonatomic) IBOutlet FXDsubviewInformation *informationSubview;


- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)showInformationViewAfterDelay:(NSTimeInterval)delay;
- (void)hideInformationViewAfterDelay:(NSTimeInterval)delay;

- (void)showInformationViewWithClassName:(NSString*)className;
- (void)hideInformationView;

@end


@interface UIWindow (Essential)
+ (instancetype)newDefaultWindow;

@end