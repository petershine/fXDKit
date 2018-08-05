
#import "FXDimportEssential.h"


@interface FXDsceneLaunching : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageviewDefault;

- (void)fadeOutSceneWithCallback:(void(^)(BOOL finished, id _Nullable responseObj))finishCallback;

@end
