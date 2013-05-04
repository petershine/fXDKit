//
//  FXDsuperAssetController.m
//
//
//  Created by petershine on 5/5/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperAssetController.h"


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
@implementation FXDsuperAssetController


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	// Instance variables
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
	
	FXDLog(@"self.mainScrollView.frame: %@", NSStringFromCGRect(self.mainScrollView.frame));
	FXDLog(@"self.imageviewPhotoItem.frame: %@", NSStringFromCGRect(self.imageviewPhotoItem.frame));
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {	FXDLog_DEFAULT;
	FXDLog(@"interfaceOrientation: %d, duration: %f frame: %@ bounds: %@", interfaceOrientation, duration, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
	
	FXDLog(@"self.mainScrollView.frame: %@", NSStringFromCGRect(self.mainScrollView.frame));
	FXDLog(@"self.imageviewPhotoItem.frame: %@", NSStringFromCGRect(self.imageviewPhotoItem.frame));
	
	[self configureItemScrollviewZoomValueShouldAnimate:YES];
	[self configureItemScrollviewContentInset];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {	FXDLog_DEFAULT;
	FXDLog(@"fromInterfaceOrientation: %d frame: %@ bounds: %@", fromInterfaceOrientation, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
	
	FXDLog(@"self.mainScrollView.frame: %@", NSStringFromCGRect(self.mainScrollView.frame));
	FXDLog(@"self.imageviewPhotoItem.frame: %@", NSStringFromCGRect(self.imageviewPhotoItem.frame));
	
	
	LOGEVENT_DEFAULT;
	
	[self configureItemScrollviewContentInset];
}


#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//MARK: Skip if reusing this instance when changing direction
	FXDLog(@"self.imageviewPhotoItem.image: %@", self.imageviewPhotoItem.image);
	
	if (self.imageviewPhotoItem.image) {
		[self configureItemScrollviewZoomValueShouldAnimate:NO];
		[self configureItemScrollviewContentInset];
		
		return;
	}
	
	
	if (self.mainMoviePlayer && self.periodicObserver == nil) {
		[self configurePeriodicObserver];
		
		return;
	}
	
	
	if (self.asset == nil) {
		return;
	}
	
	
	if ([[self.asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
		
		self.itemViewerType = itemViewerPhoto;
		
		self.mainMovieDisplayView.hidden = YES;
		self.buttonPlay.hidden = YES;
		
		
		[[FXDWindow applicationWindow] showDefaultProgressView];
		
		[[NSOperationQueue new] addOperationWithBlock:^{
			ALAssetRepresentation *defaultRepresentation = [self.asset defaultRepresentation];
			
			CGImageRef fullResolutionImageRef = [defaultRepresentation fullResolutionImage];
			CGFloat scale = [[UIScreen mainScreen] scale];
			
			ALAssetOrientation assetOrientation = [defaultRepresentation orientation];
			FXDLog(@"scale: %f assetOrientation: %d", scale, assetOrientation);
			
			UIImage *fullImage = [UIImage imageWithCGImage:fullResolutionImageRef scale:scale orientation:(UIImageOrientation)assetOrientation];
			FXDLog(@"fullImage.imageOrientation: %d fullImage.size: %@", fullImage.imageOrientation, NSStringFromCGSize(fullImage.size));
			
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				self.imageviewPhotoItem.image = fullImage;
				
				CGRect modifiedFrame = self.imageviewPhotoItem.frame;
				modifiedFrame.origin = CGPointZero;
				modifiedFrame.size = self.imageviewPhotoItem.image.size;
				
				[self.imageviewPhotoItem setFrame:modifiedFrame];
				
				[self.mainScrollView setContentSize:modifiedFrame.size];
				
				
				[self configureItemScrollviewZoomValueShouldAnimate:NO];
				[self configureItemScrollviewContentInset];
				
				[[FXDWindow applicationWindow] hideProgressView];
			}];
		}];
	}
	else if ([[self.asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
		
		self.itemViewerType = itemViewerVideo;
		
		ALAssetRepresentation *defaultRepresentation = [self.asset defaultRepresentation];
		
		if (self.mainMoviePlayer == nil) {
			self.mainMoviePlayer = [AVPlayer playerWithURL:[defaultRepresentation url]];
			
			[self.mainMovieDisplayView setMainMoviePlayer:self.mainMoviePlayer];
		}
		
		
		[self configurePeriodicObserver];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	//FXDLog(@"1.self.mainMoviePlayer.observationInfo: %@", self.mainMoviePlayer.observationInfo);
	[self.mainMoviePlayer removeTimeObserver:self.periodicObserver];
	//FXDLog(@"2.self.mainMoviePlayer.observationInfo: %@", self.mainMoviePlayer.observationInfo);
	
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

#pragma mark - Method overriding
- (NSInteger)pageIndexUsingDataSource:(NSMutableArray *)dataSource {
	NSInteger pageIndex = 0;
	
	if (self.asset && [dataSource containsObject:self.asset]) {
		pageIndex = [dataSource indexOfObject:self.asset];
	}
	
	return pageIndex;
}

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
	
	
	[self.mainMoviePlayer seekToTime:CMTimeMakeWithSeconds(0.0, 1.0)
				   completionHandler:^(BOOL finished) {
					   [self.mainMoviePlayer play];
					   
					   [self.buttonPlay fadeOutThenHidden];
				   }];
}


#pragma mark - Public
- (void)configureItemScrollviewZoomValueShouldAnimate:(BOOL)shouldAnimate {
	
	FXDLog(@"self.mainScrollView.bounds.size: %@", NSStringFromCGSize(self.mainScrollView.bounds.size));
	FXDLog(@"self.imageviewPhotoItem.image.size: %@", NSStringFromCGSize(self.imageviewPhotoItem.image.size));
	
	// calculate min/max zoomscale
	CGFloat xScale = self.mainScrollView.bounds.size.width  / self.imageviewPhotoItem.image.size.width;
	CGFloat yScale = self.mainScrollView.bounds.size.height / self.imageviewPhotoItem.image.size.height;
	FXDLog(@"xScale: %f, yScale: %f", xScale, yScale);
	
	
	CGFloat minScale = MIN(xScale, yScale);
	CGFloat maxScale = 2.0;	//MARK: if you want to limit to screen size: MAX(xScale, yScale);
	
	if (minScale > 1.0) {
		minScale = 1.0;
	}
	
	FXDLog(@"minScale: %f, maxScale: %f", minScale, maxScale);
	
	self.mainScrollView.maximumZoomScale = maxScale;
	self.mainScrollView.minimumZoomScale = minScale;
	
	
	FXDLog(@"1.self.imageviewPhotoItem.frame: %@", NSStringFromCGRect(self.imageviewPhotoItem.frame));
	[self.mainScrollView setZoomScale:self.mainScrollView.minimumZoomScale animated:shouldAnimate];
	FXDLog(@"2.self.imageviewPhotoItem.frame: %@", NSStringFromCGRect(self.imageviewPhotoItem.frame));
}

- (void)configureItemScrollviewContentInset {
	CGFloat horizontalInset = (self.mainScrollView.frame.size.width -self.imageviewPhotoItem.frame.size.width)/2.0;
	CGFloat verticalInset = (self.mainScrollView.frame.size.height -self.imageviewPhotoItem.frame.size.height)/2.0;
	
	if (horizontalInset < 0.0) {
		horizontalInset = 0.0;
	}
	
	if (verticalInset < 0.0) {
		verticalInset = 0.0;
	}
	
	UIEdgeInsets modifiedInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
	
	[self.mainScrollView setContentInset:modifiedInset];
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


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageviewPhotoItem;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[self configureItemScrollviewContentInset];
}

@end