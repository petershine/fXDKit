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

- (MKZoomScale)zoomScale;

- (NSString*)snappedGridIndexForGridDimension:(CGFloat)gridDimension forZoomScale:(MKZoomScale)zoomScale atCoordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapRect)snappedGridMapRectForGridDimension:(CGFloat)gridDimension forZoomScale:(MKZoomScale)zoomScale atGridIndex:(NSString*)gridIndex;

- (CGPoint)offsetFromLastRegion:(MKCoordinateRegion)lastRegion toCurrentRegion:(MKCoordinateRegion)currentRegion;

- (MKMapRect)visibleMapRectAtCoordinate:(CLLocationCoordinate2D)coordinate withScale:(CGFloat)scale;

- (void)configureRegionForZoomScale:(MKZoomScale)zoomScale atCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

@end
