//
//  FXDBarButtonItem.m
//
//
//  Created by petershine on 8/14/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDBarButtonItem.h"

#pragma mark - Public implementation
@implementation FXDBarButtonItem


#pragma mark - Memory management

#pragma mark - Initialization

@end


#pragma mark - Category
@implementation UIBarButtonItem (Added)
- (void)customizeWithNormalImage:(UIImage*)normalImage andWithHighlightedImage:(UIImage*)highlightedImage {
	
	if (self.customView == nil) {
		self.customView = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normalImage.size.width, normalImage.size.height)];
		[(UIButton*)self.customView addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
	}
	
	[(UIButton*)self.customView setImage:normalImage forState:UIControlStateNormal];
	[(UIButton*)self.customView setImage:highlightedImage forState:UIControlStateHighlighted];
}

@end