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
	
	// Primitives
    
    // Instance variables
    
    // Properties
    
    // IBOutlets
	self.backgroundColor = [UIColor clearColor];
}


#pragma mark - Accessor overriding
- (FXDviewProgress*)progressView {
	if (_progressView == nil) {
		_progressView = [FXDviewProgress viewFromNibName:nil];
		
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

	applicationWindow.progressView.hidden = NO;
}

- (void)hideProgressView {	FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	applicationWindow.progressView.hidden = YES;
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
