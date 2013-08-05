//
//  FXDsuperSlidingContainer.h
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define segueidentifierEmbeddingRoot	@"EmbeddingRoot"
#define segueidentifierFrontController	@"embedFrontController"


@interface FXDsegueEmbeddingFrontController : FXDsuperEmbedSegue
@end

@interface FXDsegueSlidingIn : FXDsuperTransitionSegue
@end

@interface FXDsegueSlidingOut : FXDsuperTransitionSegue
@end


@interface FXDsuperSlidingContainer : FXDsuperContainer

// Properties
@property (nonatomic) NSInteger minimumChildCount;

@property (strong, nonatomic) FXDViewController *frontController;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIToolbar *mainToolbar;	//TODO: find good way to remove this


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (BOOL)canAnimateWithTransitionSegue:(FXDsuperTransitionSegue*)transitionSegue;

- (void)slideInWithSegue:(FXDsegueSlidingIn*)slidingInSegue;
- (void)slideOutWithSegue:(FXDsegueSlidingOut*)slidingOutSegue;

- (void)slideOutAllLateAddedController;

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
