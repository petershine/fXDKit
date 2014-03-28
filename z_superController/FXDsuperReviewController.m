//
//  FXDsuperReviewController.m
//
//
//  Created by petershine on 5/5/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperReviewController.h"


#pragma mark - Public implementation
@implementation FXDsuperReviewController


#pragma mark - Memory management

#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];
	
	//GUIDE: Configure AFTER LOADING View
}


#pragma mark - Autorotating
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	FXDLogRect(self.mainScrollview.frame);
	FXDLogRect(self.imageviewPhoto.frame);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	
	FXDLogRect(self.mainScrollview.frame);
	FXDLogRect(self.imageviewPhoto.frame);
	
	[self.mainScrollview configureZoomValueForImageView:self.imageviewPhoto shouldAnimate:YES];
	[self.mainScrollview configureContentInsetForSubview:self.imageviewPhoto];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

	FXDLogRect(self.mainScrollview.frame);
	FXDLogRect(self.imageviewPhoto.frame);
	
	[self.mainScrollview configureContentInsetForSubview:self.imageviewPhoto];
}


#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self startDisplayingAssetRepresentation];
}

- (void)viewDidDisappear:(BOOL)animated {	FXDLog_SEPARATE_FRAME;
	[super viewDidDisappear:animated];
	
	FXDLogVariable(self.playbackManager.videoPlayer.rate);
	
	if (self.playbackManager.videoPlayer.rate > 0.0) {
		[self.playbackManager.videoPlayer pause];
		
		[self.buttonPlay fadeInFromHidden];
	}
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)startDisplayingAssetRepresentation {	FXDLog_DEFAULT;
	FXDLogObject(self.reviewedAsset);
	if (self.reviewedAsset == nil) {
		return;
	}
	

	FXDLogObject(self.imageviewPhoto.image);
	if (self.imageviewPhoto.image) {	//MARK: Skip if reusing this instance when changing direction
		[self.mainScrollview configureZoomValueForImageView:self.imageviewPhoto shouldAnimate:NO];
		[self.mainScrollview configureContentInsetForSubview:self.imageviewPhoto];

		return;
	}
	
	
	//MARK: For Video
	if ([[self.reviewedAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {

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
						
			[self.view addSubview:self.buttonPlay];
		}

		
		if (self.playbackManager == nil) {
			ALAssetRepresentation *defaultRepresentation = [self.reviewedAsset defaultRepresentation];

			self.playbackManager = [FXDsuperPlaybackManager new];

			[self.playbackManager
			 preparePlaybackManagerWithFileURL:[defaultRepresentation url]
			 withScene:self
			 withFinishCallback:^(BOOL finished, id responseObj, SEL caller) {
				 FXDLog_BLOCK(self.playbackManager, caller);
				 FXDLogBOOL(finished);
			 }];
		}
		
		return;
	}
	
	
	//MARK: For Photo	
	self.buttonPlay.hidden = YES;
	
		
	[[FXDWindow applicationWindow] showDefaultProgressView];
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 ALAssetRepresentation *defaultRepresentation = [self.reviewedAsset defaultRepresentation];
		 
		 CGImageRef fullResolutionImageRef = [defaultRepresentation fullResolutionImage];
		 CGFloat scale = [[UIScreen mainScreen] scale];
		 
		 ALAssetOrientation assetOrientation = [defaultRepresentation orientation];
		 FXDLog(@"%@ %@", _Variable(scale), _Variable(assetOrientation));
		 
		 UIImage *fullImage = [UIImage imageWithCGImage:fullResolutionImageRef scale:scale orientation:(UIImageOrientation)assetOrientation];
		 FXDLog(@"%@ %@", _Variable(fullImage.imageOrientation), _Size(fullImage.size));
		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  [self refreshWithFullImage:fullImage];
			  
			  [[FXDWindow applicationWindow] hideProgressView];
		  }];
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