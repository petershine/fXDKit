//
//  FXDsuperSlidingContainer.h
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDsegueSlidingIn : FXDsuperTransitionSegue
@end

@interface FXDsegueSlidingOut : FXDsuperTransitionSegue
@end


@interface FXDsuperSlidingContainer : FXDsuperContainer

// Properties
@property (nonatomic) NSInteger minimumChildCount;

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDView *groupUpperMenu;
@property (strong, nonatomic) IBOutlet FXDView *groupBottomMenu;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (BOOL)canAnimateWithTransitionSegue:(FXDsuperTransitionSegue*)transitionSegue;

- (void)slideInWithSegue:(FXDsegueSlidingIn*)slidingInSegue;
- (void)slideOutWithSegue:(FXDsegueSlidingOut*)slidingOutSegue;

- (void)slideOutAllLaterAddedControllerWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)configureUpperMenuViewForCurrentScene:(FXDViewController*)currentScene;
- (void)configureBottomMenuViewForCurrentScene:(FXDViewController*)currentScene;

- (SLIDING_OFFSET)slidingOffsetForSlideDirectionType:(SLIDE_DIRECTION_TYPE)slideDirectionType;
- (SLIDING_DIRECTION)slidingDirectionForSlideDirectionType:(SLIDE_DIRECTION_TYPE)slideDirectionType;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface FXDViewController (Sliding)

#pragma mark - Public
- (SLIDE_DIRECTION_TYPE)slideDirectionType;

#pragma mark -
- (BOOL)shouldCoverWhenSlidingIn;
- (BOOL)shouldStayFixed;

- (NSNumber*)offsetYforSlidingOut;

@end
