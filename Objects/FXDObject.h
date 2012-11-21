//
//  FXDObject.h
//
//
//  Created by petershine on 10/12/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

#define IMPLEMENTATION_sharedInstance	static dispatch_once_t once;static id _sharedInstance = nil;dispatch_once(&once,^{_sharedInstance = [[self alloc] init];});return _sharedInstance


#import "FXDKit.h"


@interface FXDObject : NSObject {
    // Primitives

	// Instance variables

}

// Properties


#pragma mark - Initialization


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
