
#import <fXDObjC/FXDimportEssential.h>


@interface UITextView (Essential)
- (BOOL)verticalAlignWithChangedText:(NSString*)changedText;
- (CGRect)boundingRectForChangedText:(NSString*)changedText forMaximumSize:(CGSize)maximumSize;

- (void)applyShadowColor:(UIColor*)shadowColor;

@end
