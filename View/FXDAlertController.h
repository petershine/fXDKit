

#import "FXDimportCore.h"


@interface FXDAlertController : UIAlertController

+ (_Nonnull instancetype)simpleAlertWithTitle:(nullable NSString*)title message:(nullable NSString*)message cancelButtonTitle:(nullable NSString*)cancelButtonTitle withAlertHandler:(void (^ __nullable)(UIAlertAction *_Nonnull action))alertHandler;

@end
