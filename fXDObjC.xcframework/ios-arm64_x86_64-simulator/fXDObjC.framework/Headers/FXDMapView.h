

#import <MapKit/MapKit.h>

#import <fXDObjC/FXDimportEssential.h>


@interface FXDMapView : MKMapView

@property (nonatomic) CGRect initialDisclaimerFrame;
@property (nonatomic) CGPoint disclaimerOffset;

@end


@interface MKMapView (Essential)
@property (NS_NONATOMIC_IOSONLY, readonly, strong) id disclaimerView;

@property (NS_NONATOMIC_IOSONLY, getter=isHorizontal, readonly) BOOL horizontal;

@property (NS_NONATOMIC_IOSONLY, readonly) MKZoomScale mapZoomScale;

- (CGPoint)offsetFromLastRegion:(MKCoordinateRegion)lastRegion toCurrentRegion:(MKCoordinateRegion)currentRegion;

- (MKMapRect)visibleMapRectAtCoordinate:(CLLocationCoordinate2D)coordinate withScale:(CGFloat)scale;

- (void)configureRegionForMapZoomScale:(MKZoomScale)mapZoomScale atCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

@end
