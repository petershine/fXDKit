

#import "FXDWindow.h"


@implementation FXDsubviewInformation
@end


@implementation FXDWindow

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public

#pragma mark -

#pragma mark -
- (void)showInformationViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showInformationView) object:nil];
		 [self performSelector:@selector(showInformationView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

- (void)hideInformationViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInformationView) object:nil];
		 [self performSelector:@selector(hideInformationView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

#pragma mark -
- (void)showInformationView {

	if (self.informationSubview) {
		return;
	}


	NSString *informationViewNibName = NSStringFromClass([FXDsubviewInformation class]);
	Class informationViewClass = [FXDsubviewInformation class];
	NSBundle *resourceBundle = [NSBundle bundleForClass:informationViewClass];

	UINib *nib = [UINib nibWithNibName:informationViewNibName bundle:resourceBundle];

	if (nib == nil) {
		return;
	}


	//MARK: If nib is manually loaded like this, should it NOT have inheriting Module specified?
	NSArray *viewArray = [nib instantiateWithOwner:nil options:nil];

	for (id subview in viewArray) {	//Assumes there is only one root object

		if ([[subview class] isSubclassOfClass:informationViewClass]) {
			self.informationSubview = (FXDsubviewInformation*)subview;
			break;
		}
	}

	if (self.informationSubview == nil) {
		return;
	}


	CGRect modifiedFrame = self.informationSubview.frame;
	modifiedFrame.size = self.frame.size;
	self.informationSubview.frame = modifiedFrame;

	[self addSubview:self.informationSubview];
	[self bringSubviewToFront:self.informationSubview];


	self.informationSubview.alpha = 0.0;
	self.informationSubview.hidden = NO;

	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 self.informationSubview.alpha = 1.0;
	 }];
}

- (void)hideInformationView {

	if (self.informationSubview == nil) {
		return;
	}


	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 self.informationSubview.alpha = 0.0;
	 } completion:^(BOOL finished) {
		 [self.informationSubview removeFromSuperview];
		 self.informationSubview = nil;
	 }];
}

@end
