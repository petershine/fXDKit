//
//  FXDURL.h
///
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#ifndef pathcomponentDocuments
	#define pathcomponentDocuments @"Documents/"
#endif

#ifndef pathcomponentCaches
	#define pathcomponentCaches	@"Caches/"
#endif


#import "FXDKit.h"


@interface FXDURL : NSURL {
    // Primitives
	
	// Instance variables
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

- (double)transferPercentage;

@end
