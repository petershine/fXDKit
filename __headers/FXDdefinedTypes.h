//
//  FXDdefinedTypes.h
//
//
//  Created by petershine on 4/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef FreeCamera_FXDdefinedTypes_h
#define FreeCamera_FXDdefinedTypes_h


typedef void (^FXDcallbackFinish)(SEL caller, BOOL didFinish, id responseObj);

typedef void (^FXDcallbackAlert)(id alertObj, NSInteger buttonIndex);

typedef NS_ENUM(NSInteger, SECTION_POSITION_TYPE) {
	sectionPositionOne,
	sectionPositionTop,
	sectionPositionMiddle,
	sectionPositionBottom
};


#endif
