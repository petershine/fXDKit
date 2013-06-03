//
//  FXDsuperContainer.m
//
//
//  Created by petershine on 5/1/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperContainer.h"


#pragma mark - Public implementation
@implementation FXDsuperContainer


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	//GUIDE: Remove observer, Deallocate timer, Nilify delegates, etc
}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];
	
	//GUIDE: Initialize BEFORE LOADING View
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//GUIDE: Configure AFTER LOADING View
}


#pragma mark - Autorotating

#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end