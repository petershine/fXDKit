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
@synthesize disclaimerViewOffset = _disclaimerViewOffset;

@synthesize initialDisclaimerViewFrame = _initialDisclaimerViewFrame;

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
	_initialDisclaimerViewFrame = [[self disclaimerView] frame];
	_disclaimerViewOffset = CGPointZero;
	
    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding
- (void)layoutSubviews {
	id disclaimerView = [self disclaimerView];
	
	if (disclaimerView) {
		CGRect modifiedFrame = [disclaimerView frame];
		modifiedFrame.origin.x = self.initialDisclaimerViewFrame.origin.x +self.disclaimerViewOffset.x;
		modifiedFrame.origin.y = (self.frame.size.height -self.initialDisclaimerViewFrame.size.height) +self.disclaimerViewOffset.y;
		
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

@end
