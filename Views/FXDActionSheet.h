//
//  FXDActionSheet.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDActionSheet : UIActionSheet <UIActionSheetDelegate>

// Properties
@property (strong, nonatomic) FXDblockAlertCallback callbackBlock;

// IBOutlets


#pragma mark - IBActions

#pragma mark - Public
- (instancetype)initWithTitle:(NSString *)title clickedButtonAtIndexBlock:(FXDblockAlertCallback)clickedButtonAtIndexBlock withButtonTitleArray:(NSArray*)buttonTitleArray cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIActionSheet (Added)
@end
