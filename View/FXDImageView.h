//
//  FXDImageView.h
//
//
//  Created by petershine on 2/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDImageView : UIImageView
@end


#pragma mark - Category
@interface UIImageView (Essential)
- (void)modifyHeightForContainedImage;

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;

- (void)fadeInImage:(UIImage*)fadedImage;

@end
