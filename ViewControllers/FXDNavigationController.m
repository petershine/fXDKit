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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
	FXDLog_SEPARATE;
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
	
	// IBOutlets
	self.addedShadowImageview = nil;
}

- (void)dealloc {	
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
	FXDLog_SEPARATE;
}


#pragma mark - Initialization
- (id)initWithRootViewController:(UIViewController *)rootViewController {	//FXDLog_SEPARATE;
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


#pragma mark - Accessor overriding


#pragma mark - at loadView


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];	//FXDLog_SEPARATE_FRAME;
	
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
		self.addedShadowImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.navigationBar.frame.size.height, self.navigationBar.frame.size.width, imageNavibarShadow.size.height)];
		self.addedShadowImageview.image = imageNavibarShadow;
	}
	
	[self.navigationBar addSubview:self.addedShadowImageview];
#endif
	
#ifdef imageToolbarBackground
	[self.toolbar setBackgroundImage:imageToolbarBackground forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];	
#endif
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UINavigationController (Added)
@end