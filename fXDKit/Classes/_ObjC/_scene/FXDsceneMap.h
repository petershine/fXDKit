
#import "FXDimportEssential.h"
#import "FXDMapView.h"


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
