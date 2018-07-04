
#import "FXDimportEssential.h"
#import "FXDStoryboardSegue.h"


@interface FXDcontainerCovering : UIViewController

@property (nonatomic) NSUInteger minimumChildCount;
@property (nonatomic) BOOL shouldFadeOutUncovering;

@property (nonatomic) BOOL isCovering;
@property (nonatomic) BOOL isUncovering;


@property (strong, nonatomic) IBOutlet UIView *mainNavigationbar;
@property (strong, nonatomic) IBOutlet UIView *mainToolbar;


- (void)coverWithSegue:(FXDStoryboardSegue*)coveringSegue;
- (void)uncoverWithSegue:(FXDStoryboardSegue*)uncoveringSegue;
- (void)uncoverAllSceneWithFinishCallback:(FXDcallbackFinish)finishCallback;

@end

