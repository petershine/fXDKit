//
//  FXDsceneMap.m
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsceneMap.h"



@implementation FXDsceneMap


#pragma mark - Memory management

#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	//MARK: Not useful for subclass
	/*
	if (self.mainMapview.delegate == nil) {
		[self.mainMapview setDelegate:self];
	}
	
	if (self.shouldResumeTracking) {
		[self resumeTrackingUser];
	}
	 */
}


#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public
- (void)refreshMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate {	FXDLog_OVERRIDE;
}

- (void)refreshMapviewWithAnnotationArray:(NSArray*)annotationArray {	FXDLog_OVERRIDE;
}

#pragma mark -
- (void)resumeTrackingUser {
	if (self.initialTrackingMode != MKUserTrackingModeNone) {	FXDLog_DEFAULT;
		[self.mainMapview setUserTrackingMode:self.initialTrackingMode animated:YES];
	}
}

//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	
	if (self.shouldResumeTracking) {	//MARK: Keep canceling until scrolling is stopped
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeTrackingUser) object:nil];
	}
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {	FXDLog_DEFAULT;
	
	if (self.shouldResumeTracking) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeTrackingUser) object:nil];
		[self performSelector:@selector(resumeTrackingUser) withObject:nil afterDelay:delayOneSecond inModes:@[NSRunLoopCommonModes]];
	}
}

@end