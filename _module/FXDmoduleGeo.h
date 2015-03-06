
@import CoreLocation;
@import MapKit;


#import "FXDsuperModule.h"
@interface FXDmoduleGeo : FXDsuperModule <CLLocationManagerDelegate> {
	CLLocationManager *_mainLocationManager;
}

@property (nonatomic) BOOL didStartSignificantMonitoring;

@property (nonatomic) UIBackgroundTaskIdentifier monitoringTask;

@property (strong, nonatomic) CLLocationManager *mainLocationManager;

@property (strong, nonatomic) CLLocation *lastLocation;


- (void)startMainLocationManagerWithLaunchOptions:(NSDictionary*)launchOptions;
- (void)pauseMainLocationManager;

- (void)configureUpdatingForApplicationState;
- (void)maximizeUpdatingForActiveState;
- (void)minimizeUpdatingForBackgroundState;

- (BOOL)isDistantEnoughFromLastLocation;

- (void)notifySignificantChangeWithNewLocation:(CLLocation*)newLocation;

@end


//NOTE: distance value is x10 of real meters
#define distanceDiagonalTenthKilo	1190.0
#define distanceDiagonalFirstKilo	148.0

#define dimensionMinimumTile	32.0
#define distanceDiagonalSatelliteMinimum	37.0


@interface FXDmoduleTile : FXDsuperModule

@property (nonatomic) MKMapRect tileMapRect;
@property (nonatomic) MKMapRect screenMapRect;


- (void)prepareTileModule;

- (CGRect)tileCGRectForMinimumDimension:(CGFloat)minimumDimension;
- (MKMapRect)tileMapRectForMinimumDiagonalDistance:(CLLocationDistance)minimumDiagonalDistance;

@end