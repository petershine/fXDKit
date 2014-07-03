
#import "FXDKit.h"


@import MapKit;


@interface FXDMapView : MKMapView

@property (nonatomic) CGRect initialDisclaimerFrame;
@property (nonatomic) CGPoint disclaimerOffset;

@end


@interface MKMapView (Essential)
- (id)disclaimerView;

- (BOOL)isHorizontal;

- (MKZoomScale)mapZoomScale;

- (CGPoint)offsetFromLastRegion:(MKCoordinateRegion)lastRegion toCurrentRegion:(MKCoordinateRegion)currentRegion;

- (MKMapRect)visibleMapRectAtCoordinate:(CLLocationCoordinate2D)coordinate withScale:(CGFloat)scale;

- (void)configureRegionForMapZoomScale:(MKZoomScale)mapZoomScale atCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

@end
