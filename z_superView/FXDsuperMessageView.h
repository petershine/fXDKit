//
//  FXDsuperMessageView.h
//
//
//  Created by petershine on 5/30/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#define buttonIndexCancel	0
#define buttonIndexAccept	1


@class FXDsuperProgressView;


@interface FXDsuperMessageView : FXDsuperProgressView

@property (nonatomic) BOOL didPressAcceptButton;

@property (copy) FXDcallbackAlert alertCallback;

// IBOutlets
@property (strong, nonatomic) IBOutlet UITextView *textviewMessage;

@property (strong, nonatomic) IBOutlet UIButton *buttonAccept;
@property (strong, nonatomic) IBOutlet UILabel *labelAccepting;


#pragma mark - IBActions
- (IBAction)pressedAcceptButton:(id)sender;

#pragma mark - Public
- (void)configureWithCancelButtonTitle:(NSString*)cancelButtonTitle withAcceptButtonTitle:(NSString*)acceptButtonTitle;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
