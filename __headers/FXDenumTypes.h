//
//  FXDenumTypes.h
//
//
//  Created by petershine on 3/23/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDenumTypes_h
#define FXDKit_FXDenumTypes_h


// FXDURL
typedef NS_ENUM(NSInteger, FILE_KIND_TYPE) {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie
};

// FXDTableViewCell
typedef NS_ENUM(NSInteger, SECTION_POSITION_TYPE) {
	sectionPositionOne,
	sectionPositionTop,
	sectionPositionMiddle,
	sectionPositionBottom
};

// FXDsuperCoveringContainer
typedef CGPoint COVERING_OFFSET;
typedef CGPoint COVERING_DIRECTION;

typedef NS_ENUM(NSInteger, COVER_DIRECTION_TYPE) {
	coverDirectionTop,
	coverDirectionBottom
};

// FXDsuperPreviewController
typedef NS_ENUM(NSInteger, ITEM_VIEWER_TYPE) {
	itemViewerPhoto,
	itemViewerVideo,
};


typedef void (^FXDblockDidFinish)(BOOL finished);

typedef void (^FXDblockAlertCallback)(id alertObj, NSInteger buttonIndex);


#endif