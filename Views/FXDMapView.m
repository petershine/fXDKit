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
	_initialDisclaimerLabelFrame = [[self disclaimerLabel] frame];
	_disclaimerLabelOffset = CGPointZero;
	
    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding
- (void)layoutSubviews {	FXDLog_VIEW_FRAME;
	id disclaimerLabel = [self disclaimerLabel];
	
	if (disclaimerLabel) {
		CGRect modifiedFrame = [disclaimerLabel frame];
		modifiedFrame.origin.x = self.initialDisclaimerLabelFrame.origin.x +self.disclaimerLabelOffset.x;
		modifiedFrame.origin.y = (self.frame.size.height -self.initialDisclaimerLabelFrame.size.height) +self.disclaimerLabelOffset.y;
		
		[disclaimerLabel setFrame:modifiedFrame];
	}
	
	FXDLog(@"disclaimerLabelOffset: %@", NSStringFromCGPoint(self.disclaimerLabelOffset));
	FXDLog(@"disclaimerLabel: %@", disclaimerLabel);
}


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation MKMapView (Added)

- (id)disclaimerLabel {
    id disclaimerLabel = nil;
	
    for (id subview in self.subviews) {
		//FXDLog(@"subview: %@", subview);
		
		if ([subview isKindOfClass:[UILabel class]]) {
			disclaimerLabel = subview;		
			break;
        }
    }
		
    return disclaimerLabel;
}

@end
