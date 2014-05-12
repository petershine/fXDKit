//
//  FXDButton.h
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//


@interface FXDButton : UIButton {
	UILabel *_customTitleLabel;
}

@property (nonatomic) CGRect initialViewFrame;

// IBOutlets
@property (strong, nonatomic) IBOutlet UILabel *customTitleLabel;


#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


@interface UIButton (Added)
- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;
- (void)replaceBackgroundImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;
@end