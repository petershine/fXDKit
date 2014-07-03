
#import "FXDKit.h"


@protocol FXDprotocolShared <NSObject>
@required
+ (instancetype)sharedInstance;
@end


@interface FXDsuperModule : NSObject
@end
