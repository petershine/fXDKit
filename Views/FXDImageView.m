//
//  FXDImageView.m
//
//
//  Created by petershine on 2/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDImageView.h"


#pragma mark - Private interface
@interface FXDImageView (Private)
@end


#pragma mark - Public implementation
@implementation FXDImageView


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
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
        [self configureForAllInitializers];
    }
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        [self configureForAllInitializers];
    }
	
    return self;
}

#pragma mark -
- (void)configureForAllInitializers {    
    // Primitives
    
    // Instance variables
    
    // Properties
    
    // IBOutlets
}

#pragma mark -
- (void)awakeFromNib {
	[super awakeFromNib];
}


#pragma mark - Accessor overriding


#pragma mark - Drawing
- (void)layoutSubviews {
	[super layoutSubviews];
	
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIImageView (Added)
- (void)modifyHeightForContainedImage {	FXDLog_DEFAULT;
	FXDLog(@"self.image: %@", self.image);
	
	self.contentMode = UIViewContentModeScaleAspectFit;
	
	if (self.image) {
		CGFloat aspectRatio = (float)self.image.size.width / (float)self.image.size.height;
		
		CGRect modifiedFrame = self.frame;
		FXDLog(@"(before)modifiedFrame: %@", NSStringFromCGRect(modifiedFrame));
		
		modifiedFrame.size.height = modifiedFrame.size.width / aspectRatio;
		FXDLog(@"(after)modifiedFrame: %@", NSStringFromCGRect(modifiedFrame));
		
		[self setFrame:modifiedFrame];
	}
}

	 
@end