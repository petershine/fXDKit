//
//  FXDAlertView.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@class FXDAlertView;

typedef void (^FXDblockButtonAtIndexClicked)(FXDAlertView *alertView, NSInteger buttonIndex);


@interface FXDAlertView : UIAlertView <UIAlertViewDelegate> {
    // Primitives

	// Instance variables
}

// Properties
@property (strong, nonatomic) id addedObj;

@property (strong, nonatomic) FXDblockButtonAtIndexClicked delegateBlock;

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public

#warning "//TODO: find why this one is causing explosive memory allocation"
- (id)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockButtonAtIndexClicked)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIAlertView (Added)
@end
