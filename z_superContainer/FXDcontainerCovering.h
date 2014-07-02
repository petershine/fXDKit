//
//  FXDcontainerCovering.h
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

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

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDView *mainNavigationbar;
@property (strong, nonatomic) IBOutlet FXDView *mainToolbar;


- (void)coverWithSegue:(FXDsegueCover*)coveringSegue;
- (void)uncoverWithSegue:(FXDsegueUncover*)uncoveringSegue;
- (void)uncoverAllSceneWithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)configureUpperMenuViewForCurrentScene:(FXDViewController*)currentScene;
- (void)configureBottomMenuViewForCurrentScene:(FXDViewController*)currentScene;

- (COVERING_OFFSET)coveringOffsetForDirectionType:(COVER_DIRECTION_TYPE)coverDirectionType;
- (COVERING_DIRECTION)coveringDirectionForDirectionType:(COVER_DIRECTION_TYPE)coverDirectionType;


@end


#pragma mark - Category
@interface FXDViewController (Covering)

#pragma mark - Public
- (COVER_DIRECTION_TYPE)coverDirectionType;

- (BOOL)shouldCoverAbove;
- (BOOL)shouldStayFixed;

- (NSNumber*)offsetYforUncovering;

- (void)didFinishAnimation;

@end
