//
//  FXDviewInformation.h
//
//
//  Created by petershine on 1/9/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDviewInformation : FXDView

// IBOutlets
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorActivity;

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage_0;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage_1;

@property (strong, nonatomic) IBOutlet UISlider *sliderProgress;
@property (strong, nonatomic) IBOutlet UIProgressView *indicatorProgress;


#pragma mark - IBActions

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
