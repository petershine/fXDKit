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
- (instancetype)instantiateViewControllerWithIdentifier:(NSString *)identifier {	FXDLog_DEFAULT;
	FXDLogObject(identifier);
	
	id instantiatedViewController = [super instantiateViewControllerWithIdentifier:identifier];
	
	return instantiatedViewController;
}


#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end

#pragma mark - Category
@implementation UIStoryboard (Essential)
+ (UIStoryboard*)storyboardWithDefaultName {	FXDLog_SEPARATE;
	NSString *storyboardName = NSStringFromClass([self class]);
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		storyboardName = [storyboardName stringByAppendingString:@"_iPad"];
	}

	FXDLogObject(storyboardName);
	
	UIStoryboard *storyboard = [self storyboardWithName:storyboardName bundle:nil];
	
	return storyboard;
}

@end