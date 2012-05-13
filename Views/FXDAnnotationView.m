//
//  FXDAnnotationView.m
//  PopTooUniversal
//
//  Created by Peter SHINe on 5/11/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAnnotationView.h"


#pragma mark - Private interface
@interface FXDAnnotationView (Private)
@end


#pragma mark - Public implementation
@implementation FXDAnnotationView


#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
    [super dealloc];
}


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
    	[self awakeFromNib];
    }
	
    return self;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	
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
	
    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation MKAnnotationView (Added)
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDefaultImage:(UIImage*)defaultImage {
	self = [self initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	
	if (self) {
#ifdef image_MapViewDefaultPin
		if (defaultImage == nil) {
			defaultImage = image_MapViewDefaultPin;
		}
#endif
		[self awakeFromNib];
		
		self.image = defaultImage;
	}
	
	return self;
}


@end
