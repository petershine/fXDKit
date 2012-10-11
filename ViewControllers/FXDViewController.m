//
//  FXDViewController.m
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDViewController.h"


#pragma mark - Public implementation
@implementation FXDViewController

#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {	FXDLog_DEFAULT;
    [super didReceiveMemoryWarning];

	FXDLog(@"_shouldSkipNilifyingOutlets: %d", _shouldSkipNilifyingOutlets);

	if (_shouldSkipNilifyingOutlets) {
		return;
	}
	
    
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
	
	// IBOutlets
}

- (void)dealloc {	
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
	FXDLog_SEPARATE;
}


#pragma mark - Initialization
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
	
	// IBOutlets
}


#pragma mark - Accessor overriding
- (NSDictionary*)presentedSegueDictionary {
	
	if (_presentedSegueDictionary == nil) {	FXDLog_OVERRIDE;
		//
	}
	
	return _presentedSegueDictionary;
}


#pragma mark - at loadView


#pragma mark - at autoRotate
- (BOOL)shouldAutorotate {	//FXDLog_SEPARATE_FRAME;
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {	//FXDLog_SEPARATE_FRAME;
	return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {	//FXDLog_SEPARATE_FRAME;
	return [super preferredInterfaceOrientationForPresentation];
	
}

// For older iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#if USE_loggingRotatingOrientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"%@ %@: %d, duration: %f frame: %@ bounds: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), toInterfaceOrientation, duration, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"%@ %@: %d, duration: %f frame: %@ bounds: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), interfaceOrientation, duration, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	FXDLog(@"%@ %@: %d frame: %@ bounds: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), fromInterfaceOrientation, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
}
#endif


#pragma mark - at viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];	FXDLog_SEPARATE_FRAME;
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];	FXDLog_SEPARATE_FRAME;
	
}

#if USE_loggingViewDrawing
- (void)viewWillLayoutSubviews {	FXDLog_SEPARATE_FRAME;
	[super viewWillLayoutSubviews];
	
	// Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
}

- (void)viewDidLayoutSubviews {	FXDLog_SEPARATE_FRAME;
	[super viewDidLayoutSubviews];
	
	// Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
}
#endif

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];	FXDLog_SEPARATE_FRAME;
	
}

- (void)viewWillDisappear:(BOOL)animated {	//FXDLog_DEFAULT;
	[super viewWillDisappear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated {	//FXDLog_DEFAULT;
	[super viewDidDisappear:animated];
	
}


#pragma mark - Overriding


#pragma mark - Segues
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_OVERRIDE;
	FXDLog(@"sender: %@", sender);
	FXDLog(@"identifier: %@", identifier);

	[super performSegueWithIdentifier:identifier sender:sender];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_OVERRIDE;
	// Invoked immediately prior to initiating a segue. Return NO to prevent the segue from firing. The default implementation returns YES. This method is not invoked when -performSegueWithIdentifier:sender: is used.
	FXDLog(@"sender: %@", sender);
	FXDLog(@"identifier: %@", identifier);
	
	return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_OVERRIDE;
	FXDLog(@"sender: %@", sender);

	FXDLog(@"fullDescription:\n%@", [segue fullDescription]);
}

	 
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
			[self customizeLeftBarbuttonWithText:NSLocalizedString(text_Back, nil)
								  andWithOnImage:onImage
								 andWithOffImage:offImage
									   forTarget:target
									   forAction:action];
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

- (void)customizeLeftBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;
	
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

- (void)customizeRightBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;
	
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

		/*
		if ([text isEqualToString:NSLocalizedString(text_Back, nil)]) {
			modifiedFrame.origin.x = 7.0;
		}
		 */
		
		UILabel *backLabel = [[UILabel alloc] initWithFrame:modifiedFrame];
		backLabel.text = text;
		backLabel.textColor = [UIColor whiteColor];
		
		//backLabel.font = [UIFont systemFontOfSize:12.0];
		backLabel.font = [UIFont boldSystemFontOfSize:12.0];

		/*
		if ([text isEqualToString:NSLocalizedString(text_Back, nil)]) {
			backLabel.textColor = [UIColor colorUsingIntegersForRed:234 forGreen:234 forBlue:234];
		}
		else if ([text isEqualToString:NSLocalizedString(text_Reset, nil)]) {
			backLabel.font = [UIFont systemFontOfSize:13.0];
		}
		 */
		
#if ENVIRONMENT_newestSDK
		backLabel.textAlignment = NSTextAlignmentCenter;
#else
		backLabel.textAlignment = UITextAlignmentCenter;
#endif
		
		backLabel.backgroundColor = [UIColor clearColor];
		
		backLabel.adjustsFontSizeToFitWidth = YES;
		
		backLabel.userInteractionEnabled = NO;
		
		[button addSubview:backLabel];
	}
	
	return button;
}

#pragma mark -
- (IBAction)exitSceneUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue {	FXDLog_OVERRIDE;
	FXDLog(@"fullDescription:\n%@", [unwindSegue fullDescription]);
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


@end