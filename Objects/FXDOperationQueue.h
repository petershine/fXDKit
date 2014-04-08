//
//  FXDOperationQueue.h
//
//
//  Created by petershine on 4/8/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


@interface FXDOperationQueue : NSOperationQueue {
	NSMutableDictionary *_operationDictionary;
}

@property (strong, nonatomic) NSMutableDictionary *operationDictionary;


#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
