
#import "FXDKit.h"


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