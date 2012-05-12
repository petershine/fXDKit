//
//  FXDActionSheet.m
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDActionSheet.h"


#pragma mark - Private interface
@interface FXDActionSheet (Private)
@end


#pragma mark - Public implementation
@implementation FXDActionSheet


#pragma mark Synthesizing
// Properties
@synthesize addedObj = _addedObj;

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Instance variables
	
	// Properties
	[_addedObj release];
	
	// IBOutlets
	
	FXDLog_DEFAULT;[super dealloc];
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self configureForAllInitializers];
    }
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self configureForAllInitializers];
    }
	
    return self;
}

- (void)configureForAllInitializers {	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(observedApplicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
	
    // Primitives
	
    // Instance variables
	
    // Properties
	_addedObj = nil;
	
    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Drawing
- (void)layoutSubviews {
	[super layoutSubviews];
	
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation
- (void)observedApplicationDidEnterBackground:(id)notification {	FXDLog_DEFAULT;
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}
	 
//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIActionSheet (Added)
@end
