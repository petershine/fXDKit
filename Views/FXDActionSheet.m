//
//  FXDActionSheet.m
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDActionSheet.h"


#pragma mark - Public implementation
@implementation FXDActionSheet


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];

#if ForDEVELOPER
	FXDLog(@"_callbackBlock: %@", _callbackBlock);
#endif

	_callbackBlock = nil;
}


#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedUIApplicationDidEnterBackground:)
	 name:UIApplicationDidEnterBackgroundNotification
	 object:nil];
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public
- (instancetype)initWithTitle:(NSString *)title clickedButtonAtIndexBlock:(FXDblockAlertCallback)clickedButtonAtIndexBlock withButtonTitleArray:(NSArray*)buttonTitleArray cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {	FXDLog_DEFAULT;
	
	self = [super initWithTitle:title
					   delegate:nil
			  cancelButtonTitle:cancelButtonTitle
		 destructiveButtonTitle:destructiveButtonTitle
			  otherButtonTitles:otherButtonTitles, nil];
	
	if (self) {
		self.callbackBlock = clickedButtonAtIndexBlock;
		[self setDelegate:self];
	}
	
	return self;
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {	FXDLog_DEFAULT;
	if (self.callbackBlock) {
		self.callbackBlock(self, self.cancelButtonIndex);
	}
	
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}

//MARK: - Delegate implementation
- (void)actionSheet:(FXDActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet.callbackBlock) {
		actionSheet.callbackBlock(actionSheet, buttonIndex);
	}
}

@end


#pragma mark - Category
@implementation UIActionSheet (Added)
@end
