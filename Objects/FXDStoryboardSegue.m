//
//  FXDStoryboardSegue.m
//
//
//  Created by petershine on 5/27/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


#import "FXDStoryboardSegue.h"


#pragma mark - Public implementation
@implementation FXDStoryboardSegue


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


#pragma mark - Property overriding


#pragma mark - Method overriding
- (NSString*)description {
	NSString *descriptionString = [super description];

	descriptionString = [descriptionString stringByAppendingFormat:@" source: %@ destination: %@", self.sourceViewController, self.destinationViewController];

	return descriptionString;
}

- (void)perform {	FXDLog_DEFAULT;
	FXDLog(@"segue: %@", self);
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIStoryboardSegue (Added)
- (NSDictionary*)fullDescription {
	NSMutableDictionary *fullDescription = [[NSMutableDictionary alloc] initWithCapacity:0];

	if (self.identifier) {
		fullDescription[@"identifier"] = self.identifier;
	}

	if (self.sourceViewController) {
		fullDescription[@"source"] = self.sourceViewController;
	}

	if (self.destinationViewController) {
		fullDescription[@"destination"] = self.destinationViewController;
	}

	if ([self respondsToSelector:@selector(popoverController)]) {
		fullDescription[@"popoverController"] = [self performSelector:@selector(popoverController)];
	}

	if ([fullDescription count] == 0) {
		fullDescription = nil;
	}
	else {
		fullDescription[@"class"] = NSStringFromClass([self class]);
	}

	return fullDescription;
}

- (BOOL)shouldUseNavigationPush {
	BOOL shouldUseNavigationPush = NO;

	id parentViewController = [(UIViewController*)self.sourceViewController performSelector:@selector(parentViewController)];

	if (parentViewController && [parentViewController isKindOfClass:[UINavigationController class]]) {

		if ([self.destinationViewController isKindOfClass:[UINavigationController class]] == NO
			&& [self.destinationViewController isKindOfClass:[UITabBarController class]] == NO
			&& [self.destinationViewController isKindOfClass:[UISplitViewController class]] == NO
			&& [self.destinationViewController isKindOfClass:[UIPopoverController class]] == NO) {

			shouldUseNavigationPush = YES;
		}
	}

	FXDLog(@"shouldUseNavigationPush: %d", shouldUseNavigationPush);
	FXDLog(@"parentViewController: %@", parentViewController);

	FXDLog(@"sourceViewController: %@", self.sourceViewController);
	FXDLog(@"destinationViewController: %@", self.destinationViewController);

	return shouldUseNavigationPush;
}

@end