//
//  FXDURL.h
//
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDURL : NSURL

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface NSURL (Added)
+ (BOOL)validateWebURLstringOrModifyURLstring:(NSString**)webURLstring;

- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error;
- (NSDictionary*)fullResourceValues;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;

- (FILE_KIND_TYPE)fileKindType;

- (NSString*)followingPathAfterPathComponent:(NSString*)pathComponent;
- (NSString*)followingPathInDocuments;

- (NSString*)fileSizeString;

#if USE_MultimediaFrameworks
#ifndef filetypeVideoDefault
	#define filetypeVideoDefault AVFileTypeQuickTimeMovie
#endif

+ (NSURL*)uniqueMovieFileURLwithPrefix:(NSString*)prefix;
#endif

@end
