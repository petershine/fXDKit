//
//  FXDActionSheet.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDActionSheet : UIActionSheet <UIActionSheetDelegate>
@property (copy) FXDcallbackAlert alertCallback;


#pragma mark - IBActions

#pragma mark - Public
- (instancetype)initWithTitle:(NSString *)title withButtonTitleArray:(NSArray*)buttonTitleArray cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIActionSheet (Added)
@end
