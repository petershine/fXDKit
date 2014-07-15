
#import "FXDKit.h"


@interface FXDPopoverBackgroundView : UIPopoverBackgroundView <FXDprotocolShared> {
	CGFloat _arrowOffset;
	UIPopoverArrowDirection _arrowDirection;
}

@property (nonatomic) BOOL shouldHideArrowView;
@property (strong, nonatomic) NSString *titleText;


@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIView *viewTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imageviewArrow;


+ (CGFloat)minimumInset;

@end
