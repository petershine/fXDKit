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
	// Instance variables

#if ForDEVELOPER
	FXDLog_DEFAULT;
	
	if (_delegateBlock) {
		FXDLog(@"_delegateBlock: %@", _delegateBlock);
	}
#endif

	//_delegateBlock = nil;
	Block_release((__bridge const void *)_delegateBlock);
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
- (id)initWithTitle:(NSString*)title message:(NSString*)message withFalseDelegate:(id<UIAlertViewDelegate>)falseDelegate clickedButtonAtIndexBlock:(FXDblockButtonAtIndexClicked)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... {

	self = [super initWithTitle:title
					   message:message
					  delegate:nil
			 cancelButtonTitle:cancelButtonTitle
			 otherButtonTitles:otherButtonTitles, nil];

	if (self) {
		if (falseDelegate == nil) {
			falseDelegate = [[self class] sharedInstance];
		}
		
		[self setDelegate:falseDelegate];

		self.delegateBlock = clickedButtonAtIndexBlock;
	}

	return self;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
- (void)alertView:(FXDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (alertView.delegateBlock) {
		alertView.delegateBlock(alertView, buttonIndex);
	}
}


@end

#pragma mark - Category
@implementation UIAlertView (Added)
@end
