//
//  FXDsuperNewsView.h
//
//
//  Created by petershine on 5/30/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

@class FXDsuperProgressView;


@interface FXDsuperNewsView : FXDsuperProgressView

// Properties
@property (assign, nonatomic) BOOL didPressAcceptButton;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIButton *buttonAccept;
@property (strong, nonatomic) IBOutlet UILabel *labelAccepting;


#pragma mark - IBActions
- (IBAction)pressedAcceptButton:(id)sender;

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
