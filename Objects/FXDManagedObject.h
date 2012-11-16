//
//  FXDManagedObject.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDManagedObject : NSManagedObject {
    // Primitives
	
	// Instance variables
}

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSManagedObject (Added)
- (void)setValuesForKeysWithDictionary:(NSDictionary*)keyedValues dateFormatter:(NSDateFormatter*)dateFormatter;

@end
