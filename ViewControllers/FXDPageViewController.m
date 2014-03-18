//
//  FXDPageViewController.m
//
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDPageViewController.h"


#pragma mark - Public implementation
@implementation FXDPageViewController


#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options {	FXDLog_DEFAULT;
	
	self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
	
	if (self) {
		[self awakeFromNib];
	}
	
	return self;
}


#pragma mark - Autorotating

#pragma mark - View Appearing

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
