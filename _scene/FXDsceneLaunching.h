
#import "FXDKit.h"


@interface FXDsceneLaunching : FXDViewController

// IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *imageviewDefault;


- (void)dismissLaunchSceneWithFinishCallback:(FXDcallbackFinish)callback;

@end
