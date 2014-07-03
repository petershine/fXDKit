//
//  FXDMapView.h
//
//
//  Created by petershine on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

@import MapKit;


@interface FXDMapView : MKMapView

@property (nonatomic) CGRect initialDisclaimerFrame;
@property (nonatomic) CGPoint disclaimerOffset;

// IBOutlets

#pragma mark - IBActions

#pragma mark - Public

#pragma mark - Observer

#pragma mark - Delegate

@end


#pragma mark - Category
@interface MKMapView (Essential)
- (id)disclaimerView;

- (BOOL)isHorizontal;

- (MKZoomScale)mapZoomScale;

- (CGPoint)offsetFromLastRegion:(MKCoordinateRegion)lastRegion toCurrentRegion:(MKCoordinateRegion)currentRegion;

- (MKMapRect)visibleMapRectAtCoordinate:(CLLocationCoordinate2D)coordinate withScale:(CGFloat)scale;

- (void)configureRegionForMapZoomScale:(MKZoomScale)mapZoomScale atCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

@end
