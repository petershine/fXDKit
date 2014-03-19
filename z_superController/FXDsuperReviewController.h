//
//  FXDsuperReviewController.h
//
//
//  Created by petershine on 5/5/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperPlaybackManager.h"


#import "FXDsuperScrollController.h"

@interface FXDsuperReviewController : FXDsuperScrollController
// Properties
@property (nonatomic) NSInteger previewPageIndex;

@property (strong, nonatomic) ALAsset *reviewedAsset;

@property (strong, nonatomic) FXDsuperPlaybackManager *playbackManager;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *imageviewPhoto;

@property (strong, nonatomic) IBOutlet UIButton *buttonPlay;


#pragma mark - Segues

#pragma mark - IBActions
- (IBAction)actionPlayOrPauseMovie:(id)sender;

#pragma mark - Public
- (void)startDisplayingAssetRepresentation;

- (void)refreshWithFullImage:(UIImage*)fullImage;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
