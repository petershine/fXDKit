//
//  FXDviewProgress.m
//
//
//  Created by petershine on 1/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDviewProgress.h"


#pragma mark - Public implementation
@implementation FXDviewProgress


#pragma mark - Memory management


#pragma mark - Initialization
- (void)awakeFromNib {
	// Primitives

	// Instance variables

	// Properties

	// IBOutlets
	[super awakeFromNib];
	
}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - IBActions
- (IBAction)pressedCancelButton:(id)sender {	FXDLog_DEFAULT;
	self.didPressCancelButton = YES;

	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		self.labelCanceling.text = NSLocalizedString(text_Canceling, nil);
	}];
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
