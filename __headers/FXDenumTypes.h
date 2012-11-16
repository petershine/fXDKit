//
//  FXDenumTypes.h
//
//
//  Created by petershine on 3/23/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

// FXDURL
typedef enum {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie,

} FILE_KIND_TYPE;


// FXDsuperCoverController
typedef enum {
	coverDirectionTop,
	coverDirectionLeft,
	coverDirectionBottom,
	coverDirectionRight,

} COVER_DIRECTION_TYPE;


// FXDTableViewCell
typedef enum {
	sectionPositionOne,
	sectionPositionTop,
	sectionPositionMiddle,
	sectionPositionBottom

} SECTION_POSITION_TYPE;
