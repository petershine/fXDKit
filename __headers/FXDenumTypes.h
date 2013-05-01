//
//  FXDenumTypes.h
//
//
//  Created by petershine on 3/23/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

// FXDURL
typedef NS_ENUM(NSInteger, FILE_KIND_TYPE) {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie
};


// FXDsuperSlidingContainer
typedef CGPoint SLIDING_OFFSET;
typedef CGPoint SLIDING_DIRECTION;

typedef NS_ENUM(NSInteger, SLIDE_DIRECTION_TYPE) {
	slideDirectionTop,
	slideDirectionLeft,
	slideDirectionBottom,
	slideDirectionRight
};


// FXDTableViewCell
typedef NS_ENUM(NSInteger, SECTION_POSITION_TYPE) {
	sectionPositionOne,
	sectionPositionTop,
	sectionPositionMiddle,
	sectionPositionBottom
};
