//
//  FXDPageViewController.m
//
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDPageViewController.h"


#pragma mark - Public implementation
@implementation FXDPageViewController


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	//GUIDE: Remove observer, Deallocate timer, Nilify delegates, etc
}


#pragma mark - Initialization
- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options {	FXDLog_DEFAULT;
	
	self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
	
	if (self) {
		[self awakeFromNib];
	}
	
	return self;
}

#pragma mark -
- (void)awakeFromNib {	FXDLog_DEFAULT;
	[super awakeFromNib];
	
	//GUIDE: Initialize BEFORE LOADING View
}

- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
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


#pragma mark - Category
@implementation UIPageViewController (Added)
@end
