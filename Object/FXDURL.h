//
//  FXDURL.h
//
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

typedef NS_ENUM(NSInteger, FILE_KIND_TYPE) {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie
};


@interface FXDURL : NSURL
@end


@interface NSURL (Essential)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error;
- (NSDictionary*)fullResourceValues;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;

- (FILE_KIND_TYPE)fileKindType;

- (NSString*)followingPathAfterPathComponent:(NSString*)pathComponent;
- (NSString*)followingPathInDocuments;

- (NSString*)fileSizeString;

@end