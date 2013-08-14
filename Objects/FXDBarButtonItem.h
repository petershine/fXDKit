//
//  FXDBarButtonItem.h
//
//
//  Created by petershine on 8/14/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

@interface FXDBarButtonItem : UIBarButtonItem

// Properties

// IBOutlets


#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIBarButtonItem (Added)
- (void)customizeWithNormalImage:(UIImage*)normalImage andWithHighlightedImage:(UIImage*)highlightedImage;

@end