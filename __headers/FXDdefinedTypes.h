//
//  FXDdefinedTypes.h
//  FreeCamera
//
//  Created by petershine on 4/18/14.
//  Copyright (c) 2014 Grovesoft. All rights reserved.
//

#ifndef FreeCamera_FXDdefinedTypes_h
#define FreeCamera_FXDdefinedTypes_h


typedef void (^FXDcallbackFinish)(SEL caller, BOOL finished, id responseObj);

typedef void (^FXDcallbackAlert)(id alertObj, NSInteger buttonIndex);


typedef NS_ENUM(NSInteger, FILE_KIND_TYPE) {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie
};

typedef NS_ENUM(NSInteger, SECTION_POSITION_TYPE) {
	sectionPositionOne,
	sectionPositionTop,
	sectionPositionMiddle,
	sectionPositionBottom
};


#endif
