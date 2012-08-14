//
//  FXDWindow.m
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDWindow.h"

#import "FXDviewProgress.h"


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
	
	if (self.progressView == nil) {
		self.progressView = [FXDviewProgress viewFromNib:nil];
		
		[self addSubview:self.progressView];
		[self bringSubviewToFront:self.progressView];
		
		FXDLog(@"self.subviews: %@", self.subviews);
		
		[self.progressView fadeInFromHidden];
	}
}

- (void)observedApplicationWindowShouldFadeOutProgressView:(NSNotification*)notification {
	
	if (self.progressView) {
		[self removeAsFadeOutSubview:self.progressView removeAfterFinished:^{	FXDLog_DEFAULT;
			self.progressView = nil;
			
			FXDLog(@"self.subviews: %@", self.subviews);
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
	
	[applicationWindow performSelector:@selector(showProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
}

+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay {
	FXDWindow *applicationWindow = [self applicationWindow];
	
	[applicationWindow performSelector:@selector(hideProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
}


@end
