
@import MapKit;

#import "FXDKit.h"


@class FXDMapView;


#import "FXDsceneTable.h"
@interface FXDsceneMap : FXDsceneTable <MKMapViewDelegate> {
	FXDMapView *_mainMapview;
}

@property (nonatomic) MKUserTrackingMode initialTrackingMode;
@property (nonatomic) BOOL shouldResumeTracking;


@property (strong, nonatomic) IBOutlet FXDMapView *mainMapview;


- (void)refreshMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)refreshMapviewWithAnnotationArray:(NSArray*)annotationArray;

- (void)resumeTrackingUser;

@end
