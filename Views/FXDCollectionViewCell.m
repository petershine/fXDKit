//
//  FXDCollectionViewCell.m
//
//
//  Created by petershine on 10/1/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDCollectionViewCell.h"


#pragma mark - Public implementation
@implementation FXDCollectionViewCell


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

}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
