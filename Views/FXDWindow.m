//
//  FXDWindow.m
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDWindow.h"


#pragma mark - Private interface
@interface FXDWindow (Private)
@end


#pragma mark - Public implementation
@implementation FXDWindow


#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Primitives
	
	// Instance variables
	
	// Properties
}


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {	//FXDLog_DEFAULT;
	[super awakeFromNib];
	
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedApplicationWindowShouldFadeInProgressView:)
						  name:notificationApplicationWindowShouldFadeInProgressView
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedApplicationWindowShouldFadeOutProgressView:)
						  name:notificationApplicationWindowShouldFadeOutProgressView
						object:nil];
	
	// Primitives
    
    // Instance variables
    
    // Properties
    
    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation
- (void)observedApplicationWindowShouldFadeInProgressView:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self showProgressViewWithNibName:nil];
}

- (void)observedApplicationWindowShouldFadeOutProgressView:(NSNotification*)notification {
	
	if (self.progressView) {
		[self removeAsFadeOutSubview:self.progressView
						afterRemoved:^{	FXDLog_DEFAULT;
							self.progressView = nil;
						}];
	}
}

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIWindow (Added)
+ (id)applicationWindow {
	FXDWindow *applicationWindow = [[UIApplication sharedApplication].delegate performSelector:@selector(window)];
	
	return applicationWindow;
}

#pragma mark -
+ (void)showProgressViewAfterDelay:(NSTimeInterval)delay {
	FXDWindow *applicationWindow = [self applicationWindow];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:applicationWindow selector:@selector(showDefaultProgressView) object:nil];
	[applicationWindow performSelector:@selector(showDefaultProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
}

+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay {
	FXDWindow *applicationWindow = [self applicationWindow];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:applicationWindow selector:@selector(hideProgressView) object:nil];
	[applicationWindow performSelector:@selector(hideProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
}

#pragma mark -
- (void)showCustomProgressView {	FXDLog_DEFAULT;
	[self showProgressViewWithNibName:nibnameCustomProgressView];
}

- (void)showDefaultProgressView {	//FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	[applicationWindow observedApplicationWindowShouldFadeInProgressView:nil];
}

- (void)showProgressViewWithNibName:(NSString*)nibName {	FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	FXDLog(@"nibName: %@", nibName);

	if (applicationWindow.progressView == nil) {
		applicationWindow.progressView = [FXDviewProgress viewFromNibName:nibName];

		[applicationWindow addSubview:applicationWindow.progressView];
		[applicationWindow bringSubviewToFront:applicationWindow.progressView];

		[applicationWindow.progressView fadeInFromHidden];
	}
}

#pragma mark -
- (void)hideProgressView {	//FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	[applicationWindow observedApplicationWindowShouldFadeOutProgressView:nil];
}


@end
