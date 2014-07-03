
#import "FXDKit.h"


@import CoreLocation;
@import MapKit;


@interface FXDmoduleGeo : FXDsuperModule <CLLocationManagerDelegate>

@property (nonatomic) BOOL didStartSignificantMonitoring;

@property (nonatomic) UIBackgroundTaskIdentifier monitoringTask;
@property (nonatomic) UIBackgroundTaskIdentifier locationUpdatingTask;

@property (strong, nonatomic) CLLocationManager *mainLocationManager;

@property (strong, nonatomic) CLLocation *lastLocation;


- (void)startMainLocationManagerWithLaunchOptions:(NSDictionary*)launchOptions;
- (void)pauseMainLocationManager;

- (void)configureUpdatingForApplicationState;
- (void)maximizeUpdatingForActiveState;
- (void)minimizeUpdatingForBackgroundState;

- (BOOL)isDistantEnoughFromLastLocation;

//MARK: For testing significantMonitoring
- (void)notifySignificantChangeWithNewLocation:(CLLocation*)newLocation;

@end
