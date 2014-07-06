

#ifndef FXDKit_FXDKit_h
#define FXDKit_FXDKit_h

@import UIKit;
@import Foundation;


#ifndef USE_ReactiveCocoa
	#warning //TODO: Decide if ReactiveCocoa is used
	#define	USE_ReactiveCocoa	FALSE
#endif

#ifndef USE_AFNetworking
	#warning //TODO: Decide if AFNetworking is used
	#define USE_AFNetworking	FALSE
#endif

#ifndef USE_GPUImage
	#warning //TODO: Decide if GPUImage is used
	#define USE_GPUImage	FALSE
#endif

#ifndef USE_LocationFrameworks
	#warning //TODO: Decide if LocationFrameworks is used
	#define USE_LocationFrameworks	FALSE
#endif

#ifndef USE_MultimediaFrameworks
	#warning //TODO: Decide if MultimediaFrameworks is used
	#define USE_MultimediaFrameworks	FALSE
#endif


#pragma mark - Callbacks
typedef void (^FXDcallbackFinish)(SEL caller, BOOL didFinish, id responseObj);
typedef void (^FXDcallbackAlert)(id alertObj, NSInteger buttonIndex);


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


#import "FXDconfigDeveloper.h"
#import "FXDconfigAnalytics.h"

#import "FXDmacroValue.h"
#import "FXDmacroFunction.h"

#import "FXDimportEssential.h"
#import "FXDimportObject.h"
#import "FXDimportView.h"

#import "FXDimportAdopted.h"

#endif
