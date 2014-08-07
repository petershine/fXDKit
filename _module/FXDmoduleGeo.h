
@import CoreLocation;
@import MapKit;

#import "FXDKit.h"


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


//MARK: distance value is x10 of real meters
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