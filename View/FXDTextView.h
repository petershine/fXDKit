
#import "FXDKit.h"


@interface FXDTextView : UITextView
@end


@interface UITextView (Essential)
- (BOOL)verticalAlignWithChangedText:(NSString*)changedText;
- (CGRect)boundingRectForChangedText:(NSString*)changedText forMaximumSize:(CGSize)maximumSize;

@end