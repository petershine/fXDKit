//
//  FXDsuperManager.m
//
//
//  Created by petershine on 4/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperManager.h"


#pragma mark - Public implementation
@implementation FXDsuperManager


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
		FXDLog_DEFAULT;
	}

	return self;
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
