
#import "FXDKit.h"


@protocol FXDprotocolShared <NSObject>
@required
+ (instancetype)sharedInstance;

@optional
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;
- (void)observedUIApplicationDidBecomeActive:(NSNotification*)notification;
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification;

- (void)observedUIApplicationDidReceiveMemoryWarning:(NSNotification*)notification;
- (void)observedUIDeviceBatteryLevelDidChange:(NSNotification*)notification;

- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification;
@end


@interface FXDsuperModule : NSObject
@end
