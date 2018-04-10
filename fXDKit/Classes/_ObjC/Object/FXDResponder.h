
#import "FXDimportEssential.h"


@interface FXDResponder : UIResponder <UIApplicationDelegate>

//MARK: To prevent app being affected when state is being changed during launching
@property (nonatomic) BOOL isAppLaunching;
@property (nonatomic) BOOL didFinishLaunching;

@property (strong, nonatomic) UIWindow *window;

@end

