//
//  FXDsuperLaunchImageController.m
//
//
//  Created by petershine on 12/17/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDsuperLaunchController.h"


#pragma mark - Public implementation
@implementation FXDsuperLaunchController


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
	if (self.imageviewDefault.image == nil) {
		if (SCREEN_SIZE_35inch) {
			self.imageviewDefault.image = [UIImage bundledImageForName:imageDefaulLaunch];
		}
		else {
			self.imageviewDefault.image = [UIImage bundledImageForName:imageDefaulLaunch568h];
		}
	}
}


#pragma mark - Autorotating
- (BOOL)shouldAutorotate {
	return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)dismissLaunchControllerWithDidFinishBlock:(void(^)(BOOL finished))didFinishBlock {
	[UIView
	 animateWithDuration:delayOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 [self.view setAlpha:0.0];
	 } completion:^(BOOL finished) {	FXDLog_DEFAULT;
		 
		 if (didFinishBlock) {
			 didFinishBlock(YES);
		 }
	 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end