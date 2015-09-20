

#import "FXDimportCore.h"

@import UIKit;
@import Foundation;


@interface UITextView (Essential)
- (BOOL)verticalAlignWithChangedText:(NSString*)changedText;
- (CGRect)boundingRectForChangedText:(NSString*)changedText forMaximumSize:(CGSize)maximumSize;

- (void)applyShadowColor:(UIColor*)shadowColor;

@end