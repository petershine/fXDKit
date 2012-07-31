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
	[defaultCenter addObserver:self selector:@selector(observedApplicationWindowShouldFadeInProgressView:) name:notificationApplicationWindowShouldFadeInProgressView object:nil];
	[defaultCenter addObserver:self selector:@selector(observedApplicationWindowShouldFadeOutProgressView:) name:notificationApplicationWindowShouldFadeOutProgressView object:nil];
	
	// Primitives
    
    // Instance variables
    
    // Properties
    
    // IBOutlets
	//self.backgroundColor = [UIColor clearColor];
}


#pragma mark - Accessor overriding
- (FXDviewProgress*)progressView {
	if (_progressView == nil) {
		_progressView = [FXDviewProgress viewFromNib:nil];
		
		[self addSubview:_progressView];
		[self bringSubviewToFront:_progressView];
		
		FXDLog_DEFAULT;
		FXDLog(@"self.subviews: %@", self.subviews);
	}
	
	return _progressView;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation
- (void)observedApplicationWindowShouldFadeInProgressView:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self.progressView fadeInFromHidden];
}

- (void)observedApplicationWindowShouldFadeOutProgressView:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self.progressView fadeOutThenHidden];
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
- (void)showProgressView {	FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	[applicationWindow observedApplicationWindowShouldFadeInProgressView:nil];
}

- (void)hideProgressView {	FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	[applicationWindow observedApplicationWindowShouldFadeOutProgressView:nil];
}

#pragma mark -
+ (void)showProgressViewAfterDelay:(NSTimeInterval)delay {
	FXDWindow *applicationWindow = [self applicationWindow];
	
	[applicationWindow performSelector:@selector(showProgressView) withObject:nil afterDelay:delay];
}

+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay {
	FXDWindow *applicationWindow = [self applicationWindow];
	
	[applicationWindow performSelector:@selector(hideProgressView) withObject:nil afterDelay:delay];
}


@end
