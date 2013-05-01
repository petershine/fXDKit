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


#pragma mark - Property overriding


#pragma mark - Method overriding
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
	
	if (DEVICE_IDIOM_iPad) {
		storyboardName = [storyboardName stringByAppendingString:@"_iPad"];
	}

	FXDLog(@"storyboardName: %@", storyboardName);
	
	UIStoryboard *storyboard = [self storyboardWithName:storyboardName bundle:nil];
	
	return storyboard;
}

@end