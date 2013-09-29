//
//  FXDAlertView.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDAlertView : UIAlertView <UIAlertViewDelegate>
// Properties
@property (copy) FXDblockAlertCallback callbackBlock;

// IBOutlets


#pragma mark - IBActions

#pragma mark - Public
#warning "//TODO: Remove otherButtonTitles usage"
+ (FXDAlertView*)showAlertWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockAlertCallback)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDblockAlertCallback)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIAlertView (Added)
@end
