//
//  FXDsuperProgressView.h
//
//
//  Created by petershine on 1/9/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef nibnameCustomProgressView
	#define nibnameCustomProgressView NSStringFromClass([self class])
#endif


@interface FXDsuperProgressView : FXDView

// Properties
@property (assign, nonatomic) BOOL didPressCancelButton;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIView *viewIndicatorGroup;

@property (strong, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorActivity;

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage_0;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage_1;

@property (strong, nonatomic) IBOutlet UISlider *sliderProgress;
@property (strong, nonatomic) IBOutlet UIProgressView *indicatorProgress;

@property (strong, nonatomic) IBOutlet UIButton *buttonCancel;
@property (strong, nonatomic) IBOutlet UILabel *labelCanceling;


#pragma mark - IBActions
- (IBAction)pressedCancelButton:(id)sender;

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end