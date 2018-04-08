
#import "FXDimportEssential.h"


@interface FXDsceneLaunching : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageviewDefault;


- (void)dismissLaunchSceneWithFinishCallback:(FXDcallbackFinish)callback;

@end
