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
@synthesize progressView = _progressView;


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
	
	// IBOutlets
	[_progressView release];
	
    [super dealloc];
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self configureForAllInitializers];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self configureForAllInitializers];
    }
	
    return self;
}

- (void)configureForAllInitializers {	
    // Primitives
    
    // Instance variables
    
    // Properties
    
    // IBOutlets
}


#pragma mark - Accessor overriding
- (FXDviewProgress*)progressView {
	if (_progressView == nil) {
		_progressView = [FXDviewProgress loadedViewUsingDefaultNIB];
		
		[self addSubview:_progressView];
		[self bringSubviewToFront:_progressView];
		
		FXDLog_DEFAULT;
		FXDLog(@"self.subviews: %@", self.subviews);
	}
	
	return _progressView;
}


#pragma mark - Drawing
- (void)layoutSubviews {	//FXDLog_SEPARATE;
	[super layoutSubviews];
	
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIWindow (Added)
+ (id)applicationWindow {
	FXDWindow *applicationWindow = [[UIApplication sharedApplication].delegate performSelector:@selector(window)];
	
	return applicationWindow;
}

#pragma mark -
+ (void)showProgressView {	FXDLog_DEFAULT;
	FXDWindow *appWindow = [self applicationWindow];

	@synchronized(appWindow) {
		appWindow.progressView.hidden = NO;
	}
}

+ (void)hideProgressView {	FXDLog_DEFAULT;
	FXDWindow *appWindow = [self applicationWindow];

	@synchronized(appWindow) {
		appWindow.progressView.hidden = YES;
	}
}


@end
