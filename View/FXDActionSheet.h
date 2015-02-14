
#import "FXDimportCore.h"


@interface FXDActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (copy) FXDcallbackAlert alertCallback;


- (instancetype)initWithTitle:(NSString *)title withButtonTitleArray:(NSArray*)buttonTitleArray cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback;

@end
