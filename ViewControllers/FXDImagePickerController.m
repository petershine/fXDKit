//
//  FXDImagePickerController.m
//
//
//  Created by Anonymous on 3/4/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDImagePickerController.h"


#pragma mark - Private interface
@interface FXDImagePickerController (Private)
@end


#pragma mark - Public implementation
@implementation FXDImagePickerController

#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
}

- (void)viewDidUnload {	// Release any retained subviews of the main view.
    [super viewDidUnload];
	
	// IBOutlets - nilifyIBOutlets called by super
    //[self nilifyIBOutlets];
}

- (void)dealloc {	
	// Instance variables
	
	// Properties
	
	// IBOutlets - nilifyIBOutlets called by super
    [self nilifyIBOutlets];
	
	FXDLog_SEPARATE;
	
    [super dealloc];
}

#pragma mark -
- (void)nilifyIBOutlets {
	
	// IBOutlets
    // self.myOutlet = nil;
}


#pragma mark - Initialization
- (id)init {	FXDLog_DEFAULT;
	
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}
	
	return self;
}


#pragma mark - Accessor overriding


#pragma mark - at loadView
- (void)loadView {	FXDLog_SEPARATE;
	[super loadView];
	
	// Implement loadView to create a view hierarchy programmatically, without using a nib.
}


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {	FXDLog_SEPARATE;
    [super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewWillAppear:animated];
	
	[FXDWindow hideProgressView];
}

- (void)viewDidAppear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewWillDisappear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewDidDisappear:animated];
	
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


