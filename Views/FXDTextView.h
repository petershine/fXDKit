//
//  FXDTextView.h
//
//
//  Created by petershine on 10/30/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//


@interface FXDTextView : UITextView

// IBOutlets

#pragma mark - IBActions

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark -  Category
@interface UITextView (Added)
- (BOOL)alignVerticallyAtCenterWithChangedText:(NSString*)changedText withMaximumSize:(CGSize)maximumSize;

@end