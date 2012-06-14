//
//  FXDViewController.m
//
//
//  Created by petershine on 10/4/11.
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
@synthesize presentedSegueDictionary = _presentedSegueDictionary;
@synthesize presentingSegueName = _presentingSegueName;

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
	
	// IBOutlets
	
	FXDLog_SEPARATE;
}


#pragma mark - Initialization
#if ForDEVELOPER
- (id)initWithCoder:(NSCoder *)aDecoder {	FXDLog_SEPARATE;
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		//awakeFromNib
	}
	
	return self;
}
#endif

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {	FXDLog_SEPARATE;
	
	if (nibNameOrNil == nil) {
		NSString *filename = nil;
		NSString *resourcePath = nil;
		
		filename = NSStringFromClass([self class]);
		resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"nib"];	// Should use nib instead of xib for file type
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
			nibNameOrNil = filename;
		}
		
		FXDLog(@"resourcePath: %@ for %@", resourcePath, filename);
	}
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
		if (nibNameOrNil == nil) {
			[self awakeFromNib];
		}
    }
	
    return self;
}

- (void)awakeFromNib {	FXDLog_SEPARATE;
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties
	_presentedSegueDictionary = nil;
	_presentingSegueName = nil;
	
	// IBOutlets
}


#pragma mark - Accessor overriding
- (NSDictionary*)segueIdentifiers {
	
	if (_presentedSegueDictionary == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _presentedSegueDictionary;
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
#if ForDEVELOPER
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_OVERRIDE;
	FXDLog(@"segue: %@", segue);
	FXDLog(@"identifier: %@", segue.identifier);
	FXDLog(@"source: %@", segue.sourceViewController);
	FXDLog(@"destination: %@", segue.destinationViewController);
	FXDLog(@"sender: %@", sender);
	
}
#endif

	 
#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIViewController (Added)
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
		self.navigationItem.leftItemsSupplementBackButton = YES;
	}
}

- (void)customizeLeftBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	FXDLog_DEFAULT;
	
	UIButton *button = [self buttonWithOnImage:onImage andOffImage:offImage orWithText:text];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	
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
	
	return barButtonItem;
}

- (UIButton*)buttonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage orWithText:(NSString*)text {
	CGRect buttonFrame = CGRectMake(0.0, 0.0, onImage.size.width, onImage.size.height);
	
	UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
	
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
		
		backLabel.textAlignment = NSTextAlignmentCenter;
		
		backLabel.backgroundColor = [UIColor clearColor];
		
		backLabel.adjustsFontSizeToFitWidth = YES;
		
		backLabel.userInteractionEnabled = NO;
		
		[button addSubview:backLabel];
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
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

#pragma mark -
- (void)delayedActionForSender:(id)sender {	FXDLog_OVERRIDE;
	
}


@end