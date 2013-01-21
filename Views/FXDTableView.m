//
//  FXDTableView.m
//
//
//  Created by petershine on 1/21/13.
//  Copyright (c) 2013 Ensight. All rights reserved.
//

#import "FXDTableView.h"


#pragma mark - Public implementation
@implementation FXDTableView


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
}


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
	self = [super initWithFrame:frame style:style];

	if (self) {
		[self awakeFromNib];
	}

	return self;
}

#pragma mark -
- (void)awakeFromNib {
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets

}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation UITableView (Added)
@end
