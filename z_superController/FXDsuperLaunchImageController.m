//
//  FXDsuperLaunchImageController.m
//
//
//  Created by petershine on 12/17/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

#import "FXDsuperLaunchImageController.h"


#pragma mark - Public implementation
@implementation FXDsuperLaunchImageController


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	// Instance variables

	// Properties
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
	if (SCREEN_SIZE_35inch) {
		self.imageviewLaunch.image = [UIImage bundledImageForName:imageDefaulLaunch];
	}
	else {
		self.imageviewLaunch.image = [UIImage bundledImageForName:imageDefaulLaunch568h];
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


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end