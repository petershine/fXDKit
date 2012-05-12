//
//  FXDViewController.m
//
//
//  Created by Anonymous on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDViewController.h"


#pragma mark - Private interface
@interface FXDViewController (Private)
@end


#pragma mark - Public implementation
@implementation FXDViewController

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

- (void)viewDidUnload {
	
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


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {	FXDLog_SEPARATE;
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self configureForAllInitializers];
	}
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {	FXDLog_SEPARATE;
	NSString *filename = nil;
	NSString *resourcePath = nil;
	
	if (nibNameOrNil == nil) {
		filename = NSStringFromClass([self class]);
		resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"nib"];	// Should use nib instead of xib for file type
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
			nibNameOrNil = filename;
		}
	}
	
	FXDLog(@"resourcePath: %@ for %@", resourcePath, filename);
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
		[self configureForAllInitializers];
    }
	
    return self;
}


#pragma mark - at loadView
- (void)loadView {	FXDLog_SEPARATE;
	[super loadView];
	
}


#pragma mark - at autoRotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	FXDLog_DEFAULT;
	FXDLog(@"interfaceOrientation: %d", interfaceOrientation);
	
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
	
	return shouldAutorotate;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
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
	
	FXDLog(@"self.view.frame: %@", NSStringFromCGRect(self.view.frame));
}

- (void)viewWillLayoutSubviews {	//FXDLog_DEFAULT;
	[super viewWillLayoutSubviews];
	
}

- (void)viewDidLayoutSubviews {	//FXDLog_DEFAULT;
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


#pragma mark - Segues
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"identifier: %@", identifier);
	
	[super performSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"segue identifier: %@ sourceViewController: %@ destinationViewController: %@", segue.identifier, segue.sourceViewController, segue.destinationViewController);
	
	[super prepareForSegue:segue sender:sender];
}

	 
#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIAlertViewDelegate
- (void)alertView:(FXDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {	FXDLog_OVERRIDE;
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(FXDActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	FXDLog_OVERRIDE;
}

@end


#pragma mark - Category
@implementation UIViewController (Added)
#pragma mark - Memory management
- (void)nilifyIBOutlets {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// IBOutlets
}

#pragma mark - Initialization
- (void)configureForAllInitializers {	FXDLog_DEFAULT;
	// Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
}

#pragma mark - Public
+ (FXDNavigationController*)navigationControllerUsingInitializedInterface {
	FXDViewController *initializedInterface = [[self alloc] initWithNibName:nil bundle:nil];
	
	FXDNavigationController *naviController = [[FXDNavigationController alloc] initWithRootViewController:initializedInterface];
	[initializedInterface release];
	
	[naviController autorelease];
	
	return naviController;
}

- (void)customizeBackBarbuttonWithDefaultImagesForTarget:(id)target shouldHideForRoot:(BOOL)shouldHideForRoot {	FXDLog_DEFAULT;
	
	UIImage *offImage = nil;
	UIImage *onImage = nil;
	
	BOOL shouldUseBackTitle = NO;
	
#ifdef imageNavibarBtnBackOff
	offImage = imageNavibarBtnBackOff;
#else
	shouldUseBackTitle = YES;
#endif
	
#ifdef imageNavibarBtnBackOn
	onImage = imageNavibarBtnBackOn;
#endif
	
	SEL action = nil;
	
	FXDLog(@"navigationController.viewControllers count: %d", [self.navigationController.viewControllers count]);
	
	if ([self.navigationController.viewControllers count] > 1) {	// If there is more than 1 navigated interfaces
		
		if ([self.navigationController.viewControllers count] == 2) {			
			action = @selector(popToRootInterfaceWithAnimation:);
		}
		else {
			action = @selector(popInterfaceWithAnimation:);
		}
		
		FXDLog(@"onImage: %@, offImage: %@", onImage, offImage);
		
	}
	else {
		if (shouldHideForRoot) {
			// Do not show back button
		}
		else {
			action = @selector(dismissInterfaceWithAnimation:);
		}
	}
	
	if (action) {
		if (shouldUseBackTitle) {
			[self customizeLeftBarbuttonWithText:text_Back andWithOnImage:onImage andWithOffImage:offImage forTarget:target forAction:action];
		}
		else {
			[self customizeLeftBarbuttonWithOnImage:onImage andWithOffImage:offImage forTarget:target forAction:action];
		}
	}
	else {
		self.navigationItem.hidesBackButton = YES;
	}
}

- (void)customizeLeftBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	FXDLog_DEFAULT;
	
	UIButton *button = [self buttonWithOnImage:onImage andOffImage:offImage orWithText:text];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	[barButtonItem autorelease];
	
	[(UIViewController*)target navigationItem].leftBarButtonItem = barButtonItem;
}

- (void)customizeLeftBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;
	
	UIBarButtonItem *barButtonItem = [self barButtonWithOnImage:onImage andOffImage:offImage forTarget:target forAction:action];
	
	if (barButtonItem) {
		[(UIViewController*)target navigationItem].leftBarButtonItem = barButtonItem;
	}
}

- (void)customizeRightBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {
	
	UIButton *button = [self buttonWithOnImage:onImage andOffImage:offImage orWithText:text];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	[barButtonItem autorelease];
	
	[(UIViewController*)target navigationItem].rightBarButtonItem = barButtonItem;
}

- (void)customizeRightBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	FXDLog_DEFAULT;
	
	UIBarButtonItem *barButtonItem = [self barButtonWithOnImage:onImage andOffImage:offImage forTarget:target forAction:action];
	
	if (barButtonItem) {
		[(UIViewController*)target navigationItem].rightBarButtonItem = barButtonItem;
	}
}

#pragma mark -
- (UIBarButtonItem*)barButtonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {
	
	UIBarButtonItem *barButtonItem = nil;
	
	if (offImage) {
		UIButton *button = [self buttonWithOnImage:onImage andOffImage:offImage orWithText:nil];
		
		[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		
		barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	}
	else {
		if (action == @selector(dismissInterfaceWithAnimation:)) {
			barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:target action:action];
		}
	}
	
	if (barButtonItem) {
		[barButtonItem autorelease];
	}
	
	return barButtonItem;
}

- (UIButton*)buttonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage orWithText:(NSString*)text {
	CGRect buttonFrame = CGRectMake(0.0, 0.0, onImage.size.width, onImage.size.height);
	
	UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
	[button autorelease];
	
	[button setBackgroundImage:offImage forState:UIControlStateNormal];
	
	if (onImage) {
		[button setBackgroundImage:onImage forState:UIControlStateHighlighted];
		[button setBackgroundImage:onImage forState:UIControlStateSelected];
	}
	
	if (text) {
		CGRect modifiedFrame = buttonFrame;
		
		if ([text isEqualToString:text_Back]) {
			modifiedFrame.origin.x = 7.0;
		}
		
		UILabel *backLabel = [[UILabel alloc] initWithFrame:modifiedFrame];
		backLabel.text = text;
		backLabel.textColor = [UIColor whiteColor];
		
		backLabel.font = [UIFont systemFontOfSize:12.0];
		
		if ([text isEqualToString:text_Back]) {
			backLabel.textColor = [UIColor colorUsingIntegersForRed:234 forGreen:234 forBlue:234];
		}
		else if ([text isEqualToString:text_Reset]) {
			backLabel.font = [UIFont systemFontOfSize:13.0];
		}
		
		backLabel.textAlignment = UITextAlignmentCenter;
		
		backLabel.backgroundColor = [UIColor clearColor];
		
		backLabel.adjustsFontSizeToFitWidth = YES;
		backLabel.minimumFontSize = 10.0;
		
		backLabel.userInteractionEnabled = NO;
		
		[button addSubview:backLabel];
		[backLabel release];
	}
	
	return button;
}

#pragma mark -
- (IBAction)popToRootInterfaceWithAnimation:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)popInterfaceWithAnimation:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissInterfaceWithAnimation:(id)sender {
	
	if (self.navigationController) {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
	else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark -
- (void)startObservingNotifications {	FXDLog_DEFAULT;
	
}

- (void)customizeNavigationBar {	FXDLog_DEFAULT;
	
}

- (void)refreshInterface {	FXDLog_DEFAULT;
	
}


@end