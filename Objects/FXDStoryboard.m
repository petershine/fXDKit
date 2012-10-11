//
//  FXDStoryboard.m
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDStoryboard.h"


#pragma mark - Public implementation
@implementation FXDStoryboard


#pragma mark - Memory management


#pragma mark - Initialization
- (id)init {	FXDLog_SEPARATE;
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}
	
	return self;
}

#pragma mark - Accessor overriding



#pragma mark - Overriding
- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier {	FXDLog_DEFAULT;
	FXDLog(@"identifier: %@", identifier);
	
	id instantiatedViewController = [super instantiateViewControllerWithIdentifier:identifier];
	
	return instantiatedViewController;
}

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIStoryboard (Added)
+ (UIStoryboard*)storyboardWithDefaultName {	FXDLog_SEPARATE;
	NSString *storyboardName = NSStringFromClass([self class]);
	
	//TODO: distinguish interface idiom to select appropriate storyboard
	
	FXDLog(@"storyboardName: %@", storyboardName);
	
	UIStoryboard *storyboard = [self storyboardWithName:storyboardName bundle:nil];
	
	return storyboard;
}

@end