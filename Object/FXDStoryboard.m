

#import "FXDStoryboard.h"


@implementation FXDStoryboard

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding
- (instancetype)instantiateViewControllerWithIdentifier:(NSString *)identifier {	FXDLog_DEFAULT;
	FXDLogObject(identifier);
	
	id instantiatedViewController = [super instantiateViewControllerWithIdentifier:identifier];
	
	return instantiatedViewController;
}

#pragma mark - Public

#pragma mark - Observer

#pragma mark - Delegate

@end


@implementation UIStoryboard (Essential)
+ (UIStoryboard*)storyboardWithDefaultName {	FXDLog_SEPARATE;
	NSString *storyboardName = NSStringFromClass([self class]);
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		storyboardName = [storyboardName stringByAppendingString:@"_iPad"];
	}

	FXDLogObject(storyboardName);
	
	UIStoryboard *storyboard = [self storyboardWithName:storyboardName bundle:nil];
	
	return storyboard;
}

@end