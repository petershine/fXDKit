//
//  FXDAlertView.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDAlertView : UIAlertView <UIAlertViewDelegate>
// Properties
@property (copy) FXDcallbackAlert mainCallback;


#pragma mark - IBActions

#pragma mark - Public
+ (instancetype)showAlertWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDcallbackAlert)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle;

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDcallbackAlert)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIAlertView (Added)
@end
