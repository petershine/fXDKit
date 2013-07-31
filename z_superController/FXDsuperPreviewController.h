//
//  FXDsuperPreviewController.h
//
//
//  Created by petershine on 5/5/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


@interface FXDviewMovieDisplay : FXDView
@property (strong, nonatomic) AVPlayer *mainMoviePlayer;
@end


#import "FXDsuperScrollController.h"

@interface FXDsuperPreviewController : FXDsuperScrollController {

	ALAsset *_previewedAsset;
}

// Properties
@property (nonatomic) NSInteger previewPageIndex;

@property (nonatomic) ITEM_VIEWER_TYPE itemViewerType;

@property (strong, nonatomic) AVPlayer *mainMoviePlayer;
@property (strong, nonatomic) id periodicObserver;

@property (strong, nonatomic) ALAsset *previewedAsset;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *imageviewPhoto;

@property (strong, nonatomic) IBOutlet FXDviewMovieDisplay *displayviewMovie;
@property (strong, nonatomic) IBOutlet UIButton *buttonPlay;


#pragma mark - Segues

#pragma mark - IBActions
- (IBAction)actionPlayOrPauseMovie:(id)sender;

#pragma mark - Public
- (void)startDisplayingAssetRepresentation;

- (void)configurePeriodicObserver;

- (void)refreshWithFullImage:(UIImage*)fullImage;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
