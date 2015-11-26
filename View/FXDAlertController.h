

#import "FXDimportCore.h"


typedef void (^FXDcallbackAlert)(id alertObj, NSInteger buttonIndex);


@interface FXDAlertView : UIAlertView <UIAlertViewDelegate>

@property (copy) FXDcallbackAlert alertCallback;

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback;

@end


@interface FXDActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (copy) FXDcallbackAlert alertCallback;

- (instancetype)initWithTitle:(NSString *)title withButtonTitleArray:(NSArray*)buttonTitleArray cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback;

@end


@interface FXDAlertController : UIAlertController

+ (instancetype)showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback;

@end
