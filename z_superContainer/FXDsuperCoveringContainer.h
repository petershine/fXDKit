//
//  FXDsuperCoveringContainer.h
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDsegueCover : FXDsuperTransitionSegue
@end

@interface FXDsegueUncover : FXDsuperTransitionSegue
@end


@interface FXDsuperCoveringContainer : FXDsuperContainer

// Properties
@property (nonatomic) NSUInteger minimumChildCount;
@property (nonatomic) BOOL shouldFadeOutUncovering;

@property (nonatomic) BOOL isCovering;
@property (nonatomic) BOOL isUncovering;

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDView *mainNavigationbar;
@property (strong, nonatomic) IBOutlet FXDView *mainToolbar;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)coverWithSegue:(FXDsegueCover*)coveringSegue;
- (void)uncoverWithSegue:(FXDsegueUncover*)uncoveringSegue;
- (void)uncoverAllSceneWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)configureUpperMenuViewForCurrentScene:(FXDViewController*)currentScene;
- (void)configureBottomMenuViewForCurrentScene:(FXDViewController*)currentScene;

- (COVERING_OFFSET)coveringOffsetForDirectionType:(COVER_DIRECTION_TYPE)coverDirectionType;
- (COVERING_DIRECTION)coveringDirectionForDirectionType:(COVER_DIRECTION_TYPE)coverDirectionType;


//MARK: - Observer implementation

//MARK: - Delegate implementation

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
