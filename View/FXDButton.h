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

// IBOutlets
@property (strong, nonatomic) IBOutlet UILabel *customTitleLabel;

@end


@interface UIButton (Essential)
- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;
- (void)replaceBackgroundImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;
@end