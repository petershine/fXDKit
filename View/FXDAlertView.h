
#import "FXDKit.h"


@interface FXDAlertView : UIAlertView <UIAlertViewDelegate>

@property (copy) FXDcallbackAlert alertCallback;


+ (instancetype)showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback;

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback;

@end
