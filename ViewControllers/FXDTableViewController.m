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

- (void)viewDidUnload {	// Release any retained subviews of the main view.
	// IBOutlets
	[self nilifyIBOutlets];
	
	[super viewDidUnload];
	
	FXDLog_SEPARATE;
}

- (void)dealloc {
	// Instance variables
	
	// Properties
	
	// IBOutlets
	[self nilifyIBOutlets];
	
	FXDLog_SEPARATE;[super dealloc];
}

#pragma mark -
- (void)nilifyIBOutlets {	FXDLog_DEFAULT;
	// IBOutlets
    // self.myOutlet = nil;
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
	
	// IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - at autoRotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	BOOL shouldAutorotate = NO;
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		shouldAutorotate = YES;
	}
	else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		shouldAutorotate = YES;
	}
	
#if ForDEVELOPER
	shouldAutorotate = YES;
#endif
	
	if (shouldAutorotate) {	FXDLog_DEFAULT;
		//
	}
	
	return shouldAutorotate;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"willRotate toInterfaceOrientation: %d, duration: %f", toInterfaceOrientation, duration);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"willAnimateRotationTo interfaceOrientation: %d, duration: %f", interfaceOrientation, duration);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	FXDLog(@"didRotate fromInterfaceOrientation: %d", fromInterfaceOrientation);
}


#pragma mark - at loadView
- (void)loadView {	FXDLog_SEPARATE;
	[super loadView];
	
	// Implement loadView to create a view hierarchy programmatically, without using a nib.
}


#pragma mark - at viewDidLoad
- (void)viewDidLoad {	FXDLog_SEPARATE;
    [super viewDidLoad];
	
	FXDLog(@"self.view.frame: %@", NSStringFromCGRect(self.view.frame));
	
	
	[self startObservingNotifications];
	
	[self customizeNavigationBar];
	
	[self refreshInterface];
}

- (void)viewWillAppear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewWillAppear:animated];
	
}

- (void)viewWillLayoutSubviews {	//FXDLog_SEPARATE;
	[super viewWillLayoutSubviews];
	
}

- (void)viewDidLayoutSubviews {	//FXDLog_SEPARATE;
	[super viewDidLayoutSubviews];
	
}

- (void)viewDidAppear:(BOOL)animated {	FXDLog_SEPARATE;
	[super viewDidAppear:animated];
	
}

- (void)viewWillDisappear:(BOOL)animated {	//FXDLog_DEFAULT;
	[super viewWillDisappear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated {	//FXDLog_DEFAULT;
	[super viewDidDisappear:animated];
	
}


#pragma mark - Private


#pragma mark - Overriding
- (void)startObservingNotifications {
	[super startObservingNotifications];
}

- (void)customizeNavigationBar {
	[super customizeNavigationBar];
}

- (void)refreshInterface {
	[super refreshInterface];
}


#pragma mark - Segues
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;	
	[super performSegueWithIdentifier:identifier sender:sender];
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_DEFAULT;	
	[super prepareForSegue:segue sender:sender];
	
}


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger numberOfSections = [super numberOfSectionsInTableView:tableView];
	
	return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = [super tableView:tableView numberOfRowsInSection:section];
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FXDTableViewCell *cell = (FXDTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	return cell;
}


#pragma mark - UITableViewDelegate


@end


#pragma mark - Category
@implementation UITableViewController (Added)
@end
