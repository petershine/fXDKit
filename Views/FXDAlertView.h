//
//  FXDAlertView.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@class FXDAlertView;

typedef void (^FXDblockButtonAtIndexClicked)(FXDAlertView *alertView, NSInteger buttonIndex);


@interface FXDAlertView : UIAlertView <UIAlertViewDelegate> {
    // Primitives

	// Instance variables
	FXDblockButtonAtIndexClicked _delegateBlock;
}

// Properties
@property (strong, nonatomic) id addedObj;

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public
- (id)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockButtonAtIndexClicked)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIAlertView (Added)
@end
