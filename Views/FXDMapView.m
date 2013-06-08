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
- (MKZoomScale)zoomScale {
	MKMapRect visibleRect = self.visibleMapRect;
	
	MKZoomScale widthScale = self.frame.size.width /visibleRect.size.width;
	MKZoomScale heightScale = self.frame.size.height /visibleRect.size.height;
	
	MKZoomScale zoomScale = MIN(widthScale, heightScale);
	
	return zoomScale;
}

#pragma mark -
- (NSString*)snappedGridIndexForGridDimension:(CGFloat)gridDimension forZoomScale:(MKZoomScale)zoomScale atCoordinate:(CLLocationCoordinate2D)coordinate {
	
	CGFloat scaledDimension = gridDimension/zoomScale;
	
	MKMapPoint centerMapPoint = MKMapPointForCoordinate(coordinate);
	MKMapRect gridMapRect = MKMapRectMake(0.0, 0.0, scaledDimension, scaledDimension);
	gridMapRect.origin.x = (centerMapPoint.x -(scaledDimension/2.0));
	gridMapRect.origin.y = (centerMapPoint.y -(scaledDimension/2.0));
	
	
	//MARK: Snapping the origin
	NSInteger xIndex = (NSInteger)(gridMapRect.origin.x/scaledDimension);
	NSInteger yIndex = (NSInteger)(gridMapRect.origin.y/scaledDimension);
		
	MKMapRect snappedMapRect = gridMapRect;
	snappedMapRect.origin.x = scaledDimension *xIndex;
	snappedMapRect.origin.y = scaledDimension *yIndex;
	
	
	//MARK: Use flooring or ceiling to find approximate
	if ((gridMapRect.origin.x -snappedMapRect.origin.x) >= (scaledDimension/2.0)) {
		xIndex++;
	}
	
	if ((gridMapRect.origin.y -snappedMapRect.origin.y) >= (scaledDimension/2.0)) {
		yIndex++;
	}
	
	NSString *gridIndex = [NSString stringWithFormat:@"%d_%d", xIndex, yIndex];
	
	return gridIndex;
}

- (MKMapRect)snappedGridMapRectForGridDimension:(CGFloat)gridDimension forZoomScale:(MKZoomScale)zoomScale atGridIndex:(NSString*)gridIndex {
	
	CGFloat scaledDimension = gridDimension/zoomScale;
	
	NSArray *components = [gridIndex componentsSeparatedByString:@"_"];
	
	NSInteger xIndex = [components[0] integerValue];
	NSInteger yIndex = [components[1] integerValue];
	
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
- (MKMapRect)visibleMapRectAtCoordinate:(CLLocationCoordinate2D)coordinate withScale:(CGFloat)scale {
	MKMapPoint centerMapPoint = MKMapPointForCoordinate(coordinate);
	
	MKMapRect scaledMapRect = self.visibleMapRect;
	scaledMapRect.size.width *= scale;
	scaledMapRect.size.height *= scale;
	scaledMapRect.origin.x = centerMapPoint.x -(scaledMapRect.size.width/2.0);
	scaledMapRect.origin.y = centerMapPoint.y -(scaledMapRect.size.height/2.0);
	//FXDLog(@"scaledMapRect width: %f height: %f", scaledMapRect.size.width, scaledMapRect.size.height);
	
	return scaledMapRect;
}

@end
