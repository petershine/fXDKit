//
//  FXDActionSheet.m
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDActionSheet.h"


#pragma mark - Public implementation
@implementation FXDActionSheet


#pragma mark - Memory management
- (void)dealloc {	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
	FXDLog_DEFAULT;
}


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(observedUIApplicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
	
}
	 
//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIActionSheet (Added)
@end
