

#import "FXDimportCore.h"
//#import "FXDViewController.h"
//@interface FXDsceneLaunching : FXDViewController
@interface FXDsceneLaunching : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageviewDefault;


- (void)dismissLaunchSceneWithFinishCallback:(FXDcallbackFinish)callback;

@end
