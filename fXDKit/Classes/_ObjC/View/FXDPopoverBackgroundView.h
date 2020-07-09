
#import <fXDObjC/FXDimportEssential.h>


@interface FXDPopoverBackgroundView : UIPopoverBackgroundView {
	CGFloat _arrowOffset;
	UIPopoverArrowDirection _arrowDirection;
}

@property (nonatomic) BOOL shouldHideArrowView;
@property (strong, nonatomic) NSString *titleText;


@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIView *viewTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imageviewArrow;


+ (instancetype)sharedInstance;
+ (CGFloat)minimumInset;

@end
