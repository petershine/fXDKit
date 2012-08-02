//
//  FXDURL.h
//  EasyFileSharing
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FXDURL : NSURL {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
}

// Properties


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSURL (Added)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError **)error;
- (NSDictionary*)fullResourceValuesWithError:(NSError **)error;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;

@end
