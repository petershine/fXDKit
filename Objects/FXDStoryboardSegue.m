//
//  FXDStoryboardSegue.m
//  PopTooUniversal
//
//  Created by petershine on 5/27/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


#import "FXDStoryboardSegue.h"


#pragma mark - Private interface
@interface FXDStoryboardSegue (Private)
@end


#pragma mark - Public implementation
@implementation FXDStoryboardSegue

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management


#pragma mark - Initialization
- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {	FXDLog_DEFAULT;
	
	self = [super initWithIdentifier:identifier source:source destination:destination];

	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}

	return self;
}

#pragma mark - Accessor overriding
// Properties


#pragma mark - Private


#pragma mark - Overriding
- (void)perform {	FXDLog_OVERRIDE;
	
	BOOL shouldUseNavigationPush = NO;
	
	id presentingViewController = self.sourceViewController;
	
	id parentViewController = [(UIViewController*)self.sourceViewController performSelector:@selector(parentViewController)];
	
	if (parentViewController && [parentViewController isKindOfClass:[UINavigationController class]]) {
		
		if ([self.destinationViewController isKindOfClass:[UINavigationController class]] == NO
			&& [self.destinationViewController isKindOfClass:[UITabBarController class]] == NO
			&& [self.destinationViewController isKindOfClass:[UISplitViewController class]] == NO
			&& [self.destinationViewController isKindOfClass:[UIPopoverController class]] == NO) {
			
			shouldUseNavigationPush = YES;
		}
	}
	else if (parentViewController) {
		presentingViewController = parentViewController;
	}
	
	FXDLog(@"shouldUseNavigationPush: %d", shouldUseNavigationPush);
	FXDLog(@"parentViewController: %@", parentViewController);
	FXDLog(@"presentingViewController: %@", presentingViewController);
	FXDLog(@"sourceViewController: %@", self.sourceViewController);
	FXDLog(@"destinationViewController: %@", self.destinationViewController);
	
	if (shouldUseNavigationPush) {
		[(UINavigationController*)parentViewController pushViewController:self.destinationViewController animated:YES];
	}
	else {
		[presentingViewController presentViewController:self.destinationViewController animated:YES completion:nil];
	}
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
