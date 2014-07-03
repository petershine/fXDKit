//
//  FXDMapView.m
//
//
//  Created by petershine on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDMapView.h"



@implementation FXDMapView


#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
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
		FXDLogObject(disclaimerView);
		FXDLogObject([(UILabel*)disclaimerView font]);

		CGRect modifiedFrame = [disclaimerView frame];
		FXDLog(@"1.%@", _Rect(modifiedFrame));

		modifiedFrame.origin.x = self.initialDisclaimerFrame.origin.x +self.disclaimerOffset.x;
		modifiedFrame.origin.y = (self.frame.size.height -self.initialDisclaimerFrame.size.height) +self.disclaimerOffset.y;

		FXDLog(@"2.%@", _Rect(modifiedFrame));
		
		[disclaimerView setFrame:modifiedFrame];
	}
}


#pragma mark - IBActions

#pragma mark - Public


#pragma mark - Observer

#pragma mark - Delegate

@end



@implementation MKMapView (Essential)

- (id)disclaimerView {
    id disclaimerView = nil;
	
    for (id subview in self.subviews) {
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
- (MKZoomScale)mapZoomScale {
	MKMapRect visibleRect = self.visibleMapRect;
	
	MKZoomScale widthScale = self.frame.size.width /visibleRect.size.width;
	MKZoomScale heightScale = self.frame.size.height /visibleRect.size.height;
	
	MKZoomScale mapZoomScale = MIN(widthScale, heightScale);
	
	return mapZoomScale;
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
	
	return scaledMapRect;
}

#pragma mark -
- (void)configureRegionForMapZoomScale:(MKZoomScale)mapZoomScale atCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated {
	
	if (mapZoomScale == 0.0) {
		[self setCenterCoordinate:coordinate animated:animated];
		return;
	}
	
	
	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Variable([self mapZoomScale]), _Variable(mapZoomScale));
	
	Float64 mapWidth = self.frame.size.width /mapZoomScale;
	Float64 mapHeight = self.frame.size.height /mapZoomScale;
	FXDLog(@"%@ %@", _Variable(mapWidth), _Variable(mapHeight));
	
	MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
	
	MKMapRect mapRect = MKMapRectMake(mapPoint.x-(mapWidth/2.0),
									  mapPoint.y-(mapHeight/2.0),
									  mapWidth,
									  mapHeight);
	
	MKCoordinateRegion mapRegion = MKCoordinateRegionForMapRect(mapRect);
	
	[self setRegion:mapRegion animated:animated];
}

@end
