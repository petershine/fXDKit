
#import "FXDimportEssential.h"


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

- (void)showInformationViewAfterDelay:(NSTimeInterval)delay;
- (void)hideInformationViewAfterDelay:(NSTimeInterval)delay;

- (void)showInformationView;
- (void)hideInformationView;

@end
