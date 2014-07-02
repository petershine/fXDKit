//
//  FXDTextView.h
//
//
//  Created by petershine on 10/30/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

@interface FXDTextView : UITextView
@end


#pragma mark -  Category
@interface UITextView (Essential)
- (BOOL)verticalAlignWithChangedText:(NSString*)changedText;
- (CGRect)boundingRectForChangedText:(NSString*)changedText forMaximumSize:(CGSize)maximumSize;

@end