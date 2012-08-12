//
//  FXDURL.m
///
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDURL.h"


#pragma mark - Private interface
@interface FXDURL (Private)
@end


#pragma mark - Public implementation
@implementation FXDURL

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSURL (Added)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error {	FXDLog_DEFAULT;
	NSArray *ubiquitousItemKeys = @[NSURLIsUbiquitousItemKey,
								   NSURLUbiquitousItemHasUnresolvedConflictsKey,
								   NSURLUbiquitousItemIsDownloadedKey,
								   NSURLUbiquitousItemIsDownloadingKey,
								   NSURLUbiquitousItemIsUploadedKey,
								   NSURLUbiquitousItemIsUploadingKey];
	
	NSDictionary *resourceValues = [self resourceValuesForKeys:ubiquitousItemKeys error:error];
	
	return resourceValues;
}

- (NSDictionary*)fullResourceValuesWithError:(NSError **)error {
	NSMutableDictionary *resourceValues = [[NSMutableDictionary alloc] initWithDictionary:[self resourceValuesForUbiquitousItemKeysWithError:error]];
	
	[resourceValues setValuesForKeysWithDictionary:[self resourceValuesForKeys:nil error:error]];
	
	return resourceValues;	
}

#pragma mark -
- (NSString*)unicodeAbsoluteString {
	return [[self absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDate*)attributeModificationDate {
	NSDate *attributeModificationDate = nil;
	
	NSError *error = nil;
	
	[self getResourceValue:&attributeModificationDate forKey:NSURLAttributeModificationDateKey error:&error];
	
	FXDLog_ERROR;
	
	return attributeModificationDate;
}

#pragma mark -
- (FILE_KIND_TYPE)fileKindType {
	FILE_KIND_TYPE fileKindType = fileKindUndefined;
	
	NSString *typeIdentifier = nil;
	
	NSError *error = nil;
	
	[self getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:&error];
	
	FXDLog_ERROR;
	
	if ([typeIdentifier isEqual:(NSString*)kUTTypeImage]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypeJPEG]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypeJPEG2000]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypeTIFF]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypePICT]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypeGIF]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypePNG]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypeQuickTimeImage]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypeAppleICNS]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypeBMP]
		|| [typeIdentifier isEqualToString:(NSString*)kUTTypeICO]) {
		
		fileKindType = fileKindImage;
	}
	
	return fileKindType;
}


@end