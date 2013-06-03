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
- (MKCoordinateRegion)snappedGridRegionForGridDimension:(CGFloat)gridDimension atCoordinate:(CLLocationCoordinate2D)coordinate {	//FXDLog_DEFAULT;
	
	MKMapRect gridMapRect = [self snappedGridMapRectForGridDimension:gridDimension atCoordinate:coordinate];
	
	MKCoordinateRegion gridRegion = MKCoordinateRegionForMapRect(gridMapRect);
	
	return gridRegion;
}

- (MKMapRect)snappedGridMapRectForGridDimension:(CGFloat)gridDimension atCoordinate:(CLLocationCoordinate2D)coordinate {
	
	CGFloat scaledDimension = gridDimension/[self minimumZoomScale];
	
	MKMapPoint centerMapPoint = MKMapPointForCoordinate(coordinate);
	MKMapRect centerMapRect = MKMapRectMake(0.0, 0.0, scaledDimension, scaledDimension);
	centerMapRect.origin.x = (centerMapPoint.x -(scaledDimension/2.0));
	centerMapRect.origin.y = (centerMapPoint.y -(scaledDimension/2.0));
	
	
	//MARK: Snapping the origin
	NSInteger gridCountX = (NSInteger)(centerMapRect.origin.x/scaledDimension);
	NSInteger gridCountY = (NSInteger)(centerMapRect.origin.y/scaledDimension);
	
	
	MKMapRect gridMapRect = centerMapRect;
	gridMapRect.origin.x = scaledDimension *gridCountX;
	gridMapRect.origin.y = scaledDimension *gridCountY;
	
	//MARK: Use flooring or ceiling to find approximate
	if ((centerMapRect.origin.x -gridMapRect.origin.x) >= (scaledDimension/2.0)) {
		gridMapRect.origin.x += scaledDimension;
	}
	
	if ((centerMapRect.origin.y -gridMapRect.origin.y) >= (scaledDimension/2.0)) {
		gridMapRect.origin.y += scaledDimension;
	}
	//FXDLog(@"2.modifiedMapRect.origin.x: %f y: %f width: %f height: %f", modifiedMapRect.origin.x, modifiedMapRect.origin.y, modifiedMapRect.size.width, modifiedMapRect.size.height);
	
	return gridMapRect;
}

#pragma mark -
- (NSString*)snappedGridIndexForGridDimension:(CGFloat)gridDimension atCoordinate:(CLLocationCoordinate2D)coordinate {
	MKMapRect gridMapRect = [self snappedGridMapRectForGridDimension:gridDimension atCoordinate:coordinate];
	
	NSInteger xIndex = gridMapRect.origin.x /gridMapRect.size.width;
	NSInteger yIndex = gridMapRect.origin.y /gridMapRect.size.height;
	
	NSString *gridIndex = [NSString stringWithFormat:@"%d_%d", xIndex, yIndex];
	
	return gridIndex;
}

- (MKMapRect)snappedGridMapRectForGridDimension:(CGFloat)gridDimension atGridIndex:(NSString*)gridIndex {
	NSArray *components = [gridIndex componentsSeparatedByString:@"_"];
	
	NSInteger xIndex = [components[0] integerValue];
	NSInteger yIndex = [components[1] integerValue];
	
	CGFloat scaledDimension = gridDimension/[self minimumZoomScale];
	
	MKMapRect gridMapRect = MKMapRectMake(scaledDimension*xIndex, scaledDimension*yIndex, scaledDimension, scaledDimension);
	
	return gridMapRect;
}

#pragma mark -
- (CGPoint)offsetFromLastRegion:(MKCoordinateRegion)lastRegion toCurrentRegion:(MKCoordinateRegion)currentRegion {
	CGPoint oldCenter = [self convertCoordinate:lastRegion.center toPointToView:self];
	CGPoint newCenter = [self convertCoordinate:currentRegion.center toPointToView:self];
	
	CGPoint offset = CGPointMake((newCenter.x -oldCenter.x), (newCenter.y -oldCenter.y));
	
	return offset;
}

#pragma mark -
- (CLLocationCoordinate2D)gridCenterFromGridFrame:(CGRect)gridFrame {
	CGPoint frameCenter = CGPointMake(CGRectGetMidX(gridFrame), CGRectGetMidY(gridFrame));
	
	CLLocationCoordinate2D gridCenter = [self convertPoint:frameCenter toCoordinateFromView:self];
	
	return gridCenter;
}

- (MKMapRect)gridMapRectFromGridFrame:(CGRect)gridFrame {
	CLLocationCoordinate2D gridOrigin = [self convertPoint:gridFrame.origin toCoordinateFromView:self];
	
	MKMapPoint rectOrigin = MKMapPointForCoordinate(gridOrigin);
	
	MKZoomScale minimumZoomScale = [self minimumZoomScale];
	MKMapSize rectSize = MKMapSizeMake(gridFrame.size.width/minimumZoomScale, gridFrame.size.height/minimumZoomScale);
	
	MKMapRect gridMapRect = MKMapRectMake(rectOrigin.x, rectOrigin.y, rectSize.width, rectSize.height);
	
	return gridMapRect;
}

#pragma mark -
- (MKMapRect)visibleMapRectAtCoordinate:(CLLocationCoordinate2D)coordinate withScale:(CGFloat)scale {
	MKMapPoint centerMapPoint = MKMapPointForCoordinate(coordinate);
	
	MKMapRect scaledMapRect = self.visibleMapRect;
	FXDLog(@"1.scaledMapRect width: %f height: %f", scaledMapRect.size.width, scaledMapRect.size.height);
	
	scaledMapRect.size.width *= scale;
	scaledMapRect.size.height *= scale;
	scaledMapRect.origin.x = centerMapPoint.x -(scaledMapRect.size.width/2.0);
	scaledMapRect.origin.y = centerMapPoint.y -(scaledMapRect.size.height/2.0);
	FXDLog(@"2.scaledMapRect width: %f height: %f", scaledMapRect.size.width, scaledMapRect.size.height);
	
	return scaledMapRect;
}

@end
