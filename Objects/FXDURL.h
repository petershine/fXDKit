//
//  FXDURL.h
///
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

typedef enum {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie,
	
} FILE_KIND_TYPE;


#import "FXDKit.h"


@interface FXDURL : NSURL {
    // Primitives
	
	// Instance variables
	
	// Properties : For accessor overriding
}

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSURL (Added)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError **)error;
- (NSDictionary*)fullResourceValues;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;

- (FILE_KIND_TYPE)fileKindType;

- (NSString*)followingPathAfterPathComponent:(NSString*)pathComponent;
- (NSString*)followingPathInDocuments;

- (NSString*)fileSizeString;

@end
