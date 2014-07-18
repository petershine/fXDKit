
#import "FXDKit.h"


typedef CGPoint COVERING_OFFSET;
typedef CGPoint COVERING_DIRECTION;

typedef NS_ENUM(NSInteger, COVER_DIRECTION_TYPE) {
	coverDirectionTop,
	coverDirectionBottom
};


@interface FXDsegueCover : FXDStoryboardSegue
@end

@interface FXDsegueUncover : FXDStoryboardSegue
@end


@interface FXDcontainerCovering : FXDViewController

@property (nonatomic) NSUInteger minimumChildCount;
@property (nonatomic) BOOL shouldFadeOutUncovering;

@property (nonatomic) BOOL isCovering;
@property (nonatomic) BOOL isUncovering;


@property (weak, nonatomic) IBOutlet UIView *mainNavigationbar;
@property (weak, nonatomic) IBOutlet UIView *mainToolbar;


- (void)coverWithSegue:(FXDsegueCover*)coveringSegue;
- (void)uncoverWithSegue:(FXDsegueUncover*)uncoveringSegue;
- (void)uncoverAllSceneWithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)configureUpperMenuViewForCurrentScene:(FXDViewController*)currentScene;
- (void)configureBottomMenuViewForCurrentScene:(FXDViewController*)currentScene;

- (COVERING_OFFSET)coveringOffsetForDirectionType:(COVER_DIRECTION_TYPE)coverDirectionType;
- (COVERING_DIRECTION)coveringDirectionForDirectionType:(COVER_DIRECTION_TYPE)coverDirectionType;

@end



@interface FXDViewController (Covering)

#pragma mark - Public
- (COVER_DIRECTION_TYPE)coverDirectionType;

- (BOOL)shouldCoverAbove;
- (BOOL)shouldStayFixed;

- (NSNumber*)offsetYforUncovering;

- (void)didFinishAnimation;

@end
