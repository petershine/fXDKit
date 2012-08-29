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
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error {	//FXDLog_DEFAULT;
	NSArray *ubiquitousItemKeys = @[
	NSURLIsUbiquitousItemKey,
	NSURLUbiquitousItemHasUnresolvedConflictsKey,
	NSURLUbiquitousItemIsDownloadedKey,
	NSURLUbiquitousItemIsDownloadingKey,
	NSURLUbiquitousItemIsUploadedKey,
	NSURLUbiquitousItemIsUploadingKey,
	
	NSURLFileSizeKey,
	NSURLFileAllocatedSizeKey,
	NSURLTotalFileSizeKey,
	NSURLTotalFileAllocatedSizeKey,
	NSURLIsAliasFileKey,
	
	NSURLEffectiveIconKey,
	
	];
	
	NSDictionary *resourceValues = [self resourceValuesForKeys:ubiquitousItemKeys error:error];
	
	return resourceValues;
}

- (NSDictionary*)fullResourceValues {
	NSError *error = nil;
	
	NSMutableDictionary *resourceValues = [[NSMutableDictionary alloc] initWithDictionary:[self resourceValuesForUbiquitousItemKeysWithError:&error]];FXDLog_DEFAULT;
	
	[resourceValues setValuesForKeysWithDictionary:[self resourceValuesForKeys:nil error:&error]];FXDLog_ERROR;
	
	return resourceValues;	
}

#pragma mark -
- (NSString*)unicodeAbsoluteString {
	return [[self absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDate*)attributeModificationDate {
	
	NSError *error = nil;
	
	NSDate *attributeModificationDate = nil;
	[self getResourceValue:&attributeModificationDate forKey:NSURLAttributeModificationDateKey error:&error];FXDLog_ERROR;
	
	return attributeModificationDate;
}

#pragma mark -
- (FILE_KIND_TYPE)fileKindType {
	FILE_KIND_TYPE fileKindType = fileKindUndefined;
	
	NSError *error = nil;
	
	NSString *typeIdentifier = nil;
	[self getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:&error];FXDLog_ERRORexcept(260);
	
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
	else if ([typeIdentifier isEqual:(NSString*)kUTTypeRTF]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypePDF]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeRTFD]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeFlatRTFD]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeTXNTextAndMultimediaData]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeWebArchive]
			 
			 || [typeIdentifier rangeOfString:@"org.openxmlformats"].length > 0) {
		
		fileKindType = fileKindDocument;
	}
	else if ([typeIdentifier isEqual:(NSString*)kUTTypeAudio]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeMP3]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeMPEG4Audio]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeAppleProtectedMPEG4Audio]) {
		
		fileKindType = fileKindAudio;
	}
	else if ([typeIdentifier isEqual:(NSString*)kUTTypeMovie]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeVideo]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeQuickTimeMovie]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeMPEG]
			 || [typeIdentifier isEqualToString:(NSString*)kUTTypeMPEG4]) {
		
		fileKindType = fileKindMovie;
	}
	
	return fileKindType;
}

#pragma mark -
- (NSString*)followingPathAfterPathComponent:(NSString *)pathComponent {
	return [[[self unicodeAbsoluteString] componentsSeparatedByString:pathComponent] lastObject];
}

- (NSString*)followingPathInDocuments {
	return [self followingPathAfterPathComponent:pathcomponentDocuments];
}

#pragma mark -
- (NSString*)fileSizeText {
	NSString *fileSizeText = nil;

	
	NSError *error = nil;
	
	NSNumber *fileSize = nil;
	[self getResourceValue:&fileSize forKey:NSURLFileSizeKey error:&error];FXDLog_ERROR;
	
	
	NSInteger kiloUnit = 1024;
	
	if ([fileSize integerValue] < kiloUnit) {
		fileSizeText = [NSString stringWithFormat:@"%d B", [fileSize integerValue]];
	}
	else if ([fileSize integerValue] < (kiloUnit*kiloUnit)) {
		fileSizeText = [NSString stringWithFormat:@"%d KB", ([fileSize integerValue] /kiloUnit)];
	}
	else if ([fileSize integerValue] < (kiloUnit*kiloUnit*kiloUnit)) {
		fileSizeText = [NSString stringWithFormat:@"%d MB", ([fileSize integerValue] /(kiloUnit*kiloUnit))];
	}
	else if ([fileSize integerValue] < (kiloUnit*kiloUnit*kiloUnit*kiloUnit)) {
		fileSizeText = [NSString stringWithFormat:@"%d GB", ([fileSize integerValue] /(kiloUnit*kiloUnit*kiloUnit))];
	}
	
	return fileSizeText;
}

@end