//
//  FXDAlertView.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

typedef void (^FXDcallbackBlockForAlert)(id alertView, NSInteger buttonIndex);


@interface FXDAlertView : UIAlertView <UIAlertViewDelegate>

// Properties
@property (strong, nonatomic) id addedObj;

@property (strong, nonatomic) FXDcallbackBlockForAlert callbackBlock;

// IBOutlets


#pragma mark - IBActions

#pragma mark - Public

//TODO: find why this one is causing explosive memory allocation
- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message clickedButtonAtIndexBlock:(FXDcallbackBlockForAlert)clickedButtonAtIndexBlock cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIAlertView (Added)
@end
