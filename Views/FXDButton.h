//
//  FXDButton.h
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//


@interface FXDButton : UIButton

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet UILabel *labelCustom;


#pragma mark - IBActions

#pragma mark - Public
- (void)customizeWithTitle:(NSString*)title;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


@interface UIButton (Added)
- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;
@end