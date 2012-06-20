//
//  FXDMapView.m
//  PopTooUniversal
//
//  Created by Peter SHINe on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDMapView.h"


#pragma mark - Private interface
@interface FXDMapView (Private)
@end


#pragma mark - Public implementation
@implementation FXDMapView


#pragma mark Synthesizing
// Properties

// IBOutlets


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
	
    // Primitives
	
    // Instance variables
	
    // Properties
	_logoInitialFrame = [self logoImageView].frame;
	_logoOffset = CGPointZero;
	
    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding
- (void)layoutSubviews {	FXDLog_VIEW_FRAME;
	
	UIImageView *logoImageview = [self logoImageView];
	
	if (logoImageview) {
		CGRect modifiedFrame = logoImageview.frame;
		modifiedFrame.origin.x = self.logoInitialFrame.origin.x +self.logoOffset.x;
		modifiedFrame.origin.y = (self.frame.size.height -self.logoInitialFrame.size.height) +self.logoOffset.y;
		
		[logoImageview setFrame:modifiedFrame];
	}
	
	FXDLog(@"logoOffset: %@", NSStringFromCGPoint(self.logoOffset));
	
	FXDLog(@"logoImageView: %@", logoImageview);
}


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation MKMapView (Added)
- (UIImageView*)logoImageView {
    UIImageView *logoImageview = nil;
	
    for (UIView *subview in self.subviews) {
		if ([subview isMemberOfClass:[UIImageView class]]) {
			logoImageview = (UIImageView*)subview;			
			break;
        }
    }
	
    return logoImageview;
}


@end
