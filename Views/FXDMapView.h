//
//  FXDMapView.h
//
//
//  Created by petershine on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef gridDimensionDefault
	#define gridDimensionDefault		44.0
#endif


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

- (MKCoordinateRegion)snappedRegionForGridDimension:(CGFloat)gridDimension;
- (CGPoint)modifiedOffsetFromSnappedRegion:(MKCoordinateRegion)snappedRegion;

- (CLLocationCoordinate2D)gridCoordinateFromGridFrame:(CGRect)gridFrame fromGridLayer:(UIScrollView*)gridLayer;
- (MKMapRect)gridMapRectFromGridFrame:(CGRect)gridFrame fromGridLayer:(UIScrollView*)gridLayer forGridDimension:(CGFloat)gridDimension;

@end
