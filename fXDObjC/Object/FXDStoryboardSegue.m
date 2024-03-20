

#import "FXDStoryboardSegue.h"


@implementation FXDStoryboardSegue

#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {	FXDLog_DEFAULT
	
	self = [super initWithIdentifier:identifier source:source destination:destination];

	if (self) {
		FXDLogObject(identifier);
		FXDLogObject(source);
		FXDLogObject(destination);
	}

	return self;
}

#pragma mark - Property overriding

#pragma mark - Method overriding
- (NSString*)description {
	NSString *description = super.description;

	description = [description stringByAppendingFormat:@" %@ %@",
				   _Object(self.sourceViewController),
				   _Object(self.destinationViewController)];

	return description;
}

@end


@implementation UIStoryboardSegue (Essential)

- (BOOL)shouldUseNavigationPush {
	BOOL shouldUseNavigationPush = NO;

	id parentViewController = [(UIViewController*)self.sourceViewController performSelector:@selector(parentViewController)];

	if (parentViewController && [parentViewController isKindOfClass:[UINavigationController class]]) {

		if ([self.destinationViewController isKindOfClass:[UINavigationController class]] == NO
			&& [self.destinationViewController isKindOfClass:[UITabBarController class]] == NO
			&& [self.destinationViewController isKindOfClass:[UISplitViewController class]] == NO) {

			shouldUseNavigationPush = YES;
		}
	}

	FXDLogBOOL(shouldUseNavigationPush);
	FXDLogObject(parentViewController);

	FXDLogObject(self.sourceViewController);
	FXDLogObject(self.destinationViewController);

	return shouldUseNavigationPush;
}

- (id)mainContainerOfClass:(Class)class {
	
	id mainContainer = self.sourceViewController;
	
	if ([mainContainer isKindOfClass:class]) {
		return mainContainer;
	}
	
	
	mainContainer = ((UIViewController*)mainContainer).parentViewController;
	
	if ([mainContainer isKindOfClass:class]) {
		return mainContainer;
	}

	
	return nil;
}

@end


#pragma mark - Subclass
@implementation FXDsegueEmbedding;
- (void)perform {	FXDLog_DEFAULT
	UIViewController *parentController = (UIViewController*)self.sourceViewController;
	UIViewController *embeddedController = (UIViewController*)self.destinationViewController;
	
	[parentController addChildViewController:embeddedController];
	[parentController.view addSubview:embeddedController.view];
	[embeddedController didMoveToParentViewController:parentController];
	
	FXDLogObject(parentController.childViewControllers);
	FXDLogObject(parentController.view.subviews);
}
@end
