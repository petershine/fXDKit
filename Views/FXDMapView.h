//
//  FXDMapView.h
//
//
//  Created by petershine on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDMapView : MKMapView

// Properties
@property (assign, nonatomic) CGRect initialDisclaimerFrame;
@property (assign, nonatomic) CGPoint disclaimerOffset;

// IBOutlets


#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface MKMapView (Added)
- (id)disclaimerView;

- (BOOL)isHorizontal;

- (CGRect)centerFrameForGridDimension:(CGFloat)gridDimension;
- (MKZoomScale)minimumZoomScale;

- (MKCoordinateRegion)snappedGridRegionForGridDimension:(CGFloat)gridDimension atCoordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapRect)snappedGridMapRectForGridDimension:(CGFloat)gridDimension atCoordinate:(CLLocationCoordinate2D)coordinate;
- (CGPoint)offsetFromLastRegion:(MKCoordinateRegion)lastRegion toCurrentRegion:(MKCoordinateRegion)currentRegion;

- (CLLocationCoordinate2D)gridCenterFromGridFrame:(CGRect)gridFrame;
- (MKMapRect)gridMapRectFromGridFrame:(CGRect)gridFrame;

- (MKMapRect)visibleMapRectAtCoordinate:(CLLocationCoordinate2D)coordinate withScale:(CGFloat)scale;

@end
