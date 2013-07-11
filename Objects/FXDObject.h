//
//  FXDObject.h
//
//
//  Created by petershine on 10/12/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//


@interface FXDObject : NSObject

// Properties

#pragma mark - Initialization
#if __IPHONE_7_0
#warning "TODO: Later, refactor sharedInstace method to be used only in FXDObject
+ (instancetype)sharedInstance;
#endif

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
