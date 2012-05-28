//
//  FXDTableViewController.m
//  PopTooUniversal
//
//  Created by Peter SHINe on 4/26/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDTableViewController.h"


#pragma mark - Private interface
@interface FXDTableViewController (Private)
@end


#pragma mark - Public implementation
@implementation FXDTableViewController

#pragma mark Synthesizing
// Properties
@synthesize segueIdentifiers = _segueIdentifiers;

// IBOutlets


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {	FXDLog_DEFAULT;
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
}

- (void)viewWillUnload {
	[super viewWillUnload];
	
	FXDLog_SEPARATE;
}

- (void)viewDidUnload {
	// IBOutlets
	
	[super viewDidUnload];
	
	FXDLog_SEPARATE;
}

- (void)dealloc {
	// Instance variables
	
	// Properties
	[_segueIdentifiers release];
	
	// IBOutlets
	
	FXDLog_SEPARATE;[super dealloc];
}


#pragma mark - Initialization
- (id)initWithStyle:(UITableViewStyle)style {	FXDLog_SEPARATE;
    self = [super initWithStyle:style];
	
    if (self) {
        [self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {	FXDLog_SEPARATE;
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties
	_segueIdentifiers = nil;
	
	// IBOutlets
}


#pragma mark - Accessor overriding
- (NSDictionary*)segueIdentifiers {
	
	if (_segueIdentifiers == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _segueIdentifiers;
}


#pragma mark - at autoRotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	BOOL shouldAutorotate = NO;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		shouldAutorotate = YES;
	}
	else {
		if (interfaceOrientation == UIInterfaceOrientationPortrait) {
			shouldAutorotate = YES;
		}
	}
	
#if ForDEVELOPER
	shouldAutorotate = YES;
#endif
	
	if (shouldAutorotate) {
		FXDLog(@"%@: %d %@", NSStringFromSelector(_cmd), interfaceOrientation, NSStringFromCGRect(self.view.frame));
	}
	
	return shouldAutorotate;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"%@: %d, duration: %f %@", NSStringFromSelector(_cmd), toInterfaceOrientation, duration, NSStringFromCGRect(self.view.frame));
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"%@: %d, duration: %f %@", NSStringFromSelector(_cmd), interfaceOrientation, duration, NSStringFromCGRect(self.view.frame));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	FXDLog(@"%@: %d %@", NSStringFromSelector(_cmd), fromInterfaceOrientation, NSStringFromCGRect(self.view.frame));
}


#pragma mark - at loadView
#if ForDEVELOPER
- (void)loadView {
	[super loadView];	FXDLog_SEPARATE_FRAME;
	
}
#endif


#pragma mark - at viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];	FXDLog_SEPARATE_FRAME;
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];	FXDLog_SEPARATE_FRAME;
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];	FXDLog_SEPARATE_FRAME;
	
}

- (void)viewWillDisappear:(BOOL)animated {	//FXDLog_DEFAULT;
	[super viewWillDisappear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated {	//FXDLog_DEFAULT;
	[super viewDidDisappear:animated];
	
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"segue: %@", segue);
	FXDLog(@"identifier: %@", segue.identifier);
	FXDLog(@"source: %@", segue.sourceViewController);
	FXDLog(@"destination: %@", segue.destinationViewController);
	FXDLog(@"sender: %@", sender);
	
}


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate


@end


#pragma mark - Category
@implementation UITableViewController (Added)
@end
