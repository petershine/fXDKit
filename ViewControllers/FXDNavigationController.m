//
//  FXDNavigationController.m
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDNavigationController.h"


#pragma mark - Private interface
@interface FXDNavigationController (Private)
@end


#pragma mark - Public implementation
@implementation FXDNavigationController

#pragma mark Synthesizing
// Properties

// IBOutlets
@synthesize addedShadowImageview;


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {	//FXDLog_DEFAULT;
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

#pragma mark -
- (void)nilifyIBOutlets {
	// IBOutlets
	self.addedShadowImageview = nil;
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {	FXDLog_SEPARATE;
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		//awakeFromNib
	}
	
	return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {	FXDLog_SEPARATE;
	self  = [super initWithRootViewController:rootViewController];
	
	if (self) {
		[self awakeFromNib];
	}
	
	return self;
}

- (void)awakeFromNib {	//FXDLog_SEPARATE;
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
}


#pragma mark - at loadView
- (void)loadView {	//FXDLog_SEPARATE;
	[super loadView];
	
}


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {	//FXDLog_SEPARATE;
    [super viewDidLoad];
	
	/*
	 NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
	 fontSystemBold20, UITextAttributeFont,
	 [UIColor whiteColor], UITextAttributeTextColor,
	 nil];
	 
	 [self.navigationBar setTitleTextAttributes:textAttributes];
	 */
	
#ifdef imageNavibarBackground
	[self.navigationBar setBackgroundImage:imageNavibarBackground forBarMetrics:UIBarMetricsDefault];
#endif
	
#ifdef imageNavibarShadow
	if (self.addedShadowImageview == nil) {
		self.addedShadowImageview = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.navigationBar.frame.size.height, self.navigationBar.frame.size.width, imageNavibarShadow.size.height)] autorelease];
		self.addedShadowImageview.image = imageNavibarShadow;
	}
	
	[self.navigationBar addSubview:self.addedShadowImageview];
#endif
}

- (void)viewWillAppear:(BOOL)animated {	//FXDLog_SEPARATE;
	[super viewWillAppear:animated];
	
}

- (void)viewWillLayoutSubviews {	//FXDLog_SEPARATE;
	[super viewWillLayoutSubviews];
	
}

- (void)viewDidLayoutSubviews {	//FXDLog_SEPARATE;
	[super viewDidLayoutSubviews];

}

- (void)viewDidAppear:(BOOL)animated {	//FXDLog_SEPARATE;
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
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	//FXDLog_DEFAULT;	
	[super performSegueWithIdentifier:identifier sender:sender];
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	//FXDLog_DEFAULT;	
	[super prepareForSegue:segue sender:sender];
	
}


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UINavigationController (Added)
@end