//
//  FXDAlertView.m
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAlertView.h"


#pragma mark - Public implementation
@implementation FXDAlertView


#pragma mark - Memory management
- (void)dealloc {
	FXDAlertView *sharedAlertView = [[self class] sharedInstance];
	
#if ForDEVELOPER
	FXDLog_DEFAULT;

	if (sharedAlertView.delegateBlock) {
		FXDLog(@"sharedAlertView.delegateBlock: %@", sharedAlertView.delegateBlock);
	}

	if (_delegateBlock) {
		FXDLog(@"_delegateBlock: %@", _delegateBlock);
	}
#endif

	sharedAlertView.delegateBlock = nil;

	// Instance variables
	_delegateBlock = nil;
}


#pragma mark - Initialization
+ (FXDAlertView*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}

#pragma mark -
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
		[self awakeFromNib];
    }

    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets
	
}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - IBActions


#pragma mark - Public
- (id)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockButtonAtIndexClicked)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... {

	self = [super initWithTitle:title
					   message:message
					  delegate:nil
			 cancelButtonTitle:cancelButtonTitle
			 otherButtonTitles:otherButtonTitles, nil];

	if (self) {
		FXDAlertView *sharedAlertView = [[self class] sharedInstance];

		NSAssert1((sharedAlertView.delegateBlock == nil), @"sharedAlertView.delegateBlock: %@", sharedAlertView.delegateBlock);

		[self setDelegate:sharedAlertView];

		sharedAlertView.delegateBlock = clickedButtonAtIndexBlock;
	}

	return self;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
- (void)alertView:(FXDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (self.delegateBlock) {
		self.delegateBlock(alertView, buttonIndex);
	}
}


@end

#pragma mark - Category
@implementation UIAlertView (Added)
@end
