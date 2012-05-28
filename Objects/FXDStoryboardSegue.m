//
//  FXDStoryboardSegue.m
//  PopTooUniversal
//
//  Created by Peter SHINe on 5/27/12.
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
- (void)dealloc {
	// Instance variables

	// Properties

	[super dealloc];
}


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
	
	if ([self.sourceViewController navigationController]) {
		[[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:YES];
	}
	else {
		[self.sourceViewController presentViewController:self.destinationViewController
												animated:YES
											  completion:^{
												  //
											  }];
	}
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
