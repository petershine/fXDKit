//
//  FXDMapView.m
//
//
//  Created by petershine on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDMapView.h"


#pragma mark - Public implementation
@implementation FXDMapView


#pragma mark - Memory management

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
    	[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	self.initialDisclaimerFrame = [[self disclaimerView] frame];
	self.disclaimerOffset = CGPointZero;
}


#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)layoutSubviews {
	[super layoutSubviews];
	
	id disclaimerView = [self disclaimerView];
	
	if (disclaimerView) {
		CGRect modifiedFrame = [disclaimerView frame];
		modifiedFrame.origin.x = self.initialDisclaimerFrame.origin.x +self.disclaimerOffset.x;
		modifiedFrame.origin.y = (self.frame.size.height -self.initialDisclaimerFrame.size.height) +self.disclaimerOffset.y;
		
		[disclaimerView setFrame:modifiedFrame];
	}
}


#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation MKMapView (Added)

- (id)disclaimerView {
    id disclaimerView = nil;
	
    for (id subview in self.subviews) {
		//FXDLog(@"subview: %@", subview);
		
		if ([subview isKindOfClass:[UILabel class]]) {
			disclaimerView = subview;		
			break;
        }
		else if ([subview isKindOfClass:[UIImageView class]]) {
			disclaimerView = subview;
			break;
		}
    }
		
    return disclaimerView;
}

#pragma mark -
- (BOOL)isHorizontal {
	BOOL isHorizontal = NO;
	
	if (self.frame.size.width > self.frame.size.height) {
		isHorizontal = YES;
	}
	
	return isHorizontal;
}

#pragma mark -
- (CGRect)centerFrameForGridDimension:(CGFloat)gridDimension {
	CGRect centerFrame = CGRectMake(0.0, 0.0, gridDimension, gridDimension);
	centerFrame.origin.x = (self.frame.size.width -centerFrame.size.width)/2.0;
	centerFrame.origin.y = (self.frame.size.height -centerFrame.size.height)/2.0;
	
	return centerFrame;
}

- (MKZoomScale)minimumZoomScale {
	MKMapRect visibleRect = self.visibleMapRect;
	//FXDLog(@"visibleRect.origin.x: %f y: %f width: %f height: %f", visibleRect.origin.x, visibleRect.origin.y, visibleRect.size.width, visibleRect.size.height);
	
	MKZoomScale widthScale = self.frame.size.width /visibleRect.size.width;
	MKZoomScale heightScale = self.frame.size.height /visibleRect.size.height;
	
	MKZoomScale minimumZoomScale = MIN(widthScale, heightScale);
	//FXDLog(@"widthScale: %f, heightScale: %f minimumScale: %f", widthScale, heightScale, minimumScale);
	
	return minimumZoomScale;
}

#pragma mark -
- (MKCoordinateRegion)snappedRegionForGridDimension:(CGFloat)gridDimension {	//FXDLog_DEFAULT;
	
	MKMapPoint centerMapPoint = MKMapPointForCoordinate(self.centerCoordinate);
	
	CGFloat scaledDimension = gridDimension/[self minimumZoomScale];
	
	MKMapRect centerMapRect = MKMapRectMake(0.0, 0.0, scaledDimension, scaledDimension);
	centerMapRect.origin.x = (centerMapPoint.x -(scaledDimension/2.0));
	centerMapRect.origin.y = (centerMapPoint.y -(scaledDimension/2.0));
	
	//FXDLog(@"MKMapRectWorld.origin.x: %f y: %f width: %f height: %f", MKMapRectWorld.origin.x, MKMapRectWorld.origin.y, MKMapRectWorld.size.width, MKMapRectWorld.size.height);
	
	//MARK: Snapping the origin
	NSInteger gridCountX = (NSInteger)(centerMapRect.origin.x/scaledDimension);
	NSInteger gridCountY = (NSInteger)(centerMapRect.origin.y/scaledDimension);
	
	MKMapRect modifiedMapRect = centerMapRect;
	modifiedMapRect.origin.x = scaledDimension *gridCountX;
	modifiedMapRect.origin.y = scaledDimension *gridCountY;
	//FXDLog(@"1.modifiedMapRect.origin.x: %f y: %f width: %f height: %f", modifiedMapRect.origin.x, modifiedMapRect.origin.y, modifiedMapRect.size.width, modifiedMapRect.size.height);
	
	//MARK: Use flooring or ceiling to find approximate
	if ((centerMapRect.origin.x -modifiedMapRect.origin.x) >= (scaledDimension/2.0)) {
		modifiedMapRect.origin.x += scaledDimension;
	}
	
	if ((centerMapRect.origin.y -modifiedMapRect.origin.y) >= (scaledDimension/2.0)) {
		modifiedMapRect.origin.y += scaledDimension;
	}
	//FXDLog(@"2.modifiedMapRect.origin.x: %f y: %f width: %f height: %f", modifiedMapRect.origin.x, modifiedMapRect.origin.y, modifiedMapRect.size.width, modifiedMapRect.size.height);
	
	MKCoordinateRegion snappedRegion = MKCoordinateRegionForMapRect(modifiedMapRect);
	
	return snappedRegion;
}

- (CGPoint)modifiedOffsetFromSnappedRegion:(MKCoordinateRegion)snappedRegion {
	CGPoint oldCenter = [self convertCoordinate:snappedRegion.center toPointToView:self];
	CGPoint newCenter = [self convertCoordinate:self.centerCoordinate toPointToView:self];
	
	CGPoint addedOffset = CGPointMake((newCenter.x -oldCenter.x), (newCenter.y -oldCenter.y));
	
	CGPoint modifiedOffset = CGPointZero;
	modifiedOffset.x += addedOffset.x;
	modifiedOffset.y += addedOffset.y;
	
#if ForDEVELOPER
	if (MAX(fabs(addedOffset.x), fabs(addedOffset.y)) >= (gridDimensionDefault -1.0)) {
		FXDLog(@"addedOffset: %@ modifiedOffset: %@", NSStringFromCGPoint(addedOffset), NSStringFromCGPoint(modifiedOffset));
	}
#endif
	
	return modifiedOffset;
}

#pragma mark -
- (CLLocationCoordinate2D)gridCoordinateFromGridFrame:(CGRect)gridFrame fromGridLayer:(UIScrollView*)gridLayer {
	CGRect snappedFrame = gridFrame;
	snappedFrame.origin.x -= gridLayer.contentOffset.x;
	snappedFrame.origin.y -= gridLayer.contentOffset.y;
	
	CGPoint frameCenter = CGPointMake(gridFrame.origin.x +gridFrame.size.width, gridFrame.origin.y +gridFrame.size.height);
	
	CLLocationCoordinate2D gridCoordinate = [self convertPoint:frameCenter toCoordinateFromView:self];
	
	return gridCoordinate;
}

- (MKMapRect)gridMapRectFromGridFrame:(CGRect)gridFrame fromGridLayer:(UIScrollView*)gridLayer {
	CGRect snappedFrame = gridFrame;
	snappedFrame.origin.x -= gridLayer.contentOffset.x;
	snappedFrame.origin.y -= gridLayer.contentOffset.y;
	
	CLLocationCoordinate2D gridOriginCoordinate = [self convertPoint:snappedFrame.origin toCoordinateFromView:self];
	
	MKMapPoint rectOrigin = MKMapPointForCoordinate(gridOriginCoordinate);
	
	MKZoomScale minimumZoomScale = [self minimumZoomScale];
	MKMapSize rectSize = MKMapSizeMake(gridFrame.size.width/minimumZoomScale, gridFrame.size.height/minimumZoomScale);
	
	MKMapRect gridMapRect = MKMapRectMake(rectOrigin.x, rectOrigin.y, rectSize.width, rectSize.height);
	
	return gridMapRect;
}

@end
