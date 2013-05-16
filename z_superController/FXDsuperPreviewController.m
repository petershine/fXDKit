//
//  FXDsuperPreviewController.m
//
//
//  Created by petershine on 5/5/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperPreviewController.h"


@implementation FXDviewMovieDisplay
+ (Class)layerClass {
	return [AVPlayerLayer class];
}

#pragma mark -
- (AVPlayer*)mainMoviePlayer {
	return [(AVPlayerLayer*)[self layer] player];
}

- (void)setMainMoviePlayer:(AVPlayer*)mainMoviePlayer {
	[(AVPlayerLayer*)[self layer] setPlayer:mainMoviePlayer];
}

@end


#pragma mark - Public implementation
@implementation FXDsuperPreviewController


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {

}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];
	
	// Primitives
	
    // Instance variables
	
    // Properties
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    // IBOutlet
}


#pragma mark - Autorotating
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {	FXDLog_DEFAULT;
	FXDLog(@"toInterfaceOrientation: %d, duration: %f frame: %@ bounds: %@", toInterfaceOrientation, duration, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
	
	FXDLog(@"self.mainScrollview.frame: %@", NSStringFromCGRect(self.mainScrollview.frame));
	FXDLog(@"self.imageviewPhotoItem.frame: %@", NSStringFromCGRect(self.imageviewPhoto.frame));
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {	FXDLog_DEFAULT;
	FXDLog(@"interfaceOrientation: %d, duration: %f frame: %@ bounds: %@", interfaceOrientation, duration, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
	
	FXDLog(@"self.mainScrollview.frame: %@", NSStringFromCGRect(self.mainScrollview.frame));
	FXDLog(@"self.imageviewPhotoItem.frame: %@", NSStringFromCGRect(self.imageviewPhoto.frame));
	
	[self.mainScrollview configureZoomValueForImageView:self.imageviewPhoto shouldAnimate:YES];
	[self.mainScrollview configureContentInsetForSubview:self.imageviewPhoto];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {	FXDLog_DEFAULT;
	FXDLog(@"fromInterfaceOrientation: %d frame: %@ bounds: %@", fromInterfaceOrientation, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
	
	FXDLog(@"self.mainScrollview.frame: %@", NSStringFromCGRect(self.mainScrollview.frame));
	FXDLog(@"self.imageviewPhotoItem.frame: %@", NSStringFromCGRect(self.imageviewPhoto.frame));
	
	
	LOGEVENT_DEFAULT;
	
	[self.mainScrollview configureContentInsetForSubview:self.imageviewPhoto];
}


#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self startDisplayingAssetRepresentation];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.mainMoviePlayer removeTimeObserver:self.periodicObserver];	
	self.periodicObserver = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	if (self.mainMoviePlayer.rate > 0.0) {
		[self.mainMoviePlayer pause];
		
		[self.buttonPlay fadeInFromHidden];
	}
}


#pragma mark - Property overriding
- (ALAsset*)previewedAsset {
	if (_previewedAsset == nil) {	FXDLog_OVERRIDE;
		//SAMPLE
		/*
		_previewedAsset = globalManager.pagedContainer.mainDataSource[self.previewPageIndex];
		 */
	}
	
	return _previewedAsset;
}


#pragma mark - Method overriding

#pragma mark - Segues

#pragma mark - IBActions
- (IBAction)actionPlayOrPauseMovie:(id)sender {
	
	if (self.mainMoviePlayer.rate > 0.0) {
		[self.mainMoviePlayer pause];
		
		[self.buttonPlay fadeInFromHidden];
		
		return;
	}
	
	
	if (CMTimeGetSeconds(self.mainMoviePlayer.currentTime) != CMTimeGetSeconds(self.mainMoviePlayer.currentItem.duration)) {
		[self.mainMoviePlayer play];
		
		[self.buttonPlay fadeOutThenHidden];
		
		return;
	}
	
	
	[self.mainMoviePlayer
	 seekToTime:CMTimeMakeWithSeconds(0.0, 1.0)
	 completionHandler:^(BOOL finished) {
		 [self.mainMoviePlayer play];
		 
		 [self.buttonPlay fadeOutThenHidden];
	 }];
}


#pragma mark - Public
- (void)startDisplayingAssetRepresentation {	FXDLog_DEFAULT;
	FXDLog(@"self.previewedAsset: %@", self.previewedAsset);
	if (self.previewedAsset == nil) {
		return;
	}
	
	
	if (self.mainMoviePlayer && self.periodicObserver == nil) {
		[self configurePeriodicObserver];
		return;
	}
	
	FXDLog(@"self.imageviewPhotoItem.image: %@", self.imageviewPhoto.image);
	if (self.imageviewPhoto.image) {	//MARK: Skip if reusing this instance when changing direction
		[self.mainScrollview configureZoomValueForImageView:self.imageviewPhoto shouldAnimate:NO];
		[self.mainScrollview configureContentInsetForSubview:self.imageviewPhoto];
		return;
	}
	
	
	//MARK: For Video
	if ([[self.previewedAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
		
		self.itemViewerType = itemViewerVideo;
		
		if (self.displayviewMovie == nil) {
			self.displayviewMovie = [[FXDviewMovieDisplay alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
			self.displayviewMovie.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
			
			[self.view addSubview:self.displayviewMovie];
		}
		
		if (self.buttonPlay == nil) {
			self.buttonPlay = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
			
			[self.buttonPlay.titleLabel setFont:[UIFont boldSystemFontOfSize:25.0]];
			self.buttonPlay.titleLabel.textAlignment = NSTextAlignmentCenter;
			
			[self.buttonPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[self.buttonPlay setTitle:@"PLAY" forState:UIControlStateNormal];
			
			[self.buttonPlay setBackgroundColor:[UIColor blackColor]];
			
			self.buttonPlay.autoresizingMask = UIViewAnimationTransitionNone;
			self.buttonPlay.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
			
			self.buttonPlay.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
			
			[self.buttonPlay addTarget:self action:@selector(actionPlayOrPauseMovie:) forControlEvents:UIControlEventTouchUpInside];
			
			[self.view addSubview:self.buttonPlay];
		}
		
		
		ALAssetRepresentation *defaultRepresentation = [self.previewedAsset defaultRepresentation];
		
		if (self.mainMoviePlayer == nil) {
			self.mainMoviePlayer = [AVPlayer playerWithURL:[defaultRepresentation url]];
			
			[self.displayviewMovie setMainMoviePlayer:self.mainMoviePlayer];
		}
		
		
		[self configurePeriodicObserver];
		
		return;
	}
	
	
	//MARK: For Photo
	self.itemViewerType = itemViewerPhoto;
	
	self.displayviewMovie.hidden = YES;
	self.buttonPlay.hidden = YES;
	
	
	[[FXDWindow applicationWindow] showDefaultProgressView];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		ALAssetRepresentation *defaultRepresentation = [self.previewedAsset defaultRepresentation];
		
		CGImageRef fullResolutionImageRef = [defaultRepresentation fullResolutionImage];
		CGFloat scale = [[UIScreen mainScreen] scale];
		
		ALAssetOrientation assetOrientation = [defaultRepresentation orientation];
		FXDLog(@"scale: %f assetOrientation: %d", scale, assetOrientation);
		
		UIImage *fullImage = [UIImage imageWithCGImage:fullResolutionImageRef scale:scale orientation:(UIImageOrientation)assetOrientation];
		FXDLog(@"fullImage.imageOrientation: %d fullImage.size: %@", fullImage.imageOrientation, NSStringFromCGSize(fullImage.size));
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self refreshWithFullImage:fullImage];
			
			[[FXDWindow applicationWindow] hideProgressView];
		});
	});
}

#pragma mark -
- (void)configurePeriodicObserver {
    __weak typeof(self) _weakSelf = self;
    
	self.periodicObserver =
	[self.mainMoviePlayer
	 addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, 1.0)
	 queue:NULL
	 usingBlock:^(CMTime time) {
		 
		 NSTimeInterval currentSeconds = CMTimeGetSeconds(_weakSelf.mainMoviePlayer.currentTime);
		 NSTimeInterval duration = CMTimeGetSeconds(_weakSelf.mainMoviePlayer.currentItem.duration);
		 
		 
		 if (currentSeconds == duration) {
			 FXDLog(@"currentSeconds: %f, duration: %f", currentSeconds, duration);
			 //FXDLog(@"self.mainMoviePlayer.observationInfo: %@", self.mainMoviePlayer.observationInfo);
			 
			 [_weakSelf.mainMoviePlayer pause];
			 
			 [_weakSelf.buttonPlay fadeInFromHidden];
		 }
	 }];
}

#pragma mark -
- (void)refreshWithFullImage:(UIImage*)fullImage {
	self.imageviewPhoto.image = fullImage;
	
	CGRect modifiedFrame = self.imageviewPhoto.frame;
	modifiedFrame.origin = CGPointZero;
	modifiedFrame.size = self.imageviewPhoto.image.size;
	
	[self.imageviewPhoto setFrame:modifiedFrame];
	
	[self.mainScrollview setContentSize:modifiedFrame.size];
	
	
	[self.mainScrollview configureZoomValueForImageView:self.imageviewPhoto shouldAnimate:NO];
	[self.mainScrollview configureContentInsetForSubview:self.imageviewPhoto];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageviewPhoto;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[scrollView configureContentInsetForSubview:self.imageviewPhoto];
}

@end