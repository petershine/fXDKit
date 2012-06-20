//
//  FXDTableViewCell.h
//
//
//  Created by petershine on 10/19/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "FXDKit.h"


typedef enum {
	sectionPositionOne,
	sectionPositionTop,
	sectionPositionMiddle,
	sectionPositionBottom
	
} SECTION_POSITION_TYPE;


@interface FXDTableViewCell : UITableViewCell {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	SECTION_POSITION_TYPE _sectionPositionType;
	
	id _addedObj;
}

// Properties
@property (assign, nonatomic) SECTION_POSITION_TYPE sectionPositionType;

@property (strong, nonatomic) id addedObj;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageview;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public
- (void)customizeBackgroundWithImage:(UIImage*)image withHighlightedImage:(UIImage*)highlightedImage;


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark -  Category
@interface UITableViewCell (Added)
- (void)customizeWithMainImage:(UIImage*)mainImage withHighlightedMainImage:(UIImage*)highlightedMainImage;

- (void)modifySizeOfCellSubview:(UIView*)cellSubview;
- (void)modifyOriginXofCellSubview:(UIView*)cellSubview;
- (void)modifyOriginYofCellSubview:(UIView*)cellSubview;

@end