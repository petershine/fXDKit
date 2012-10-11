//
//  FXDURL.m
///
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDURL.h"


#pragma mark - Public implementation
@implementation FXDURL


#pragma mark - Memory management


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



#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSURL (Added)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error {	//FXDLog_DEFAULT;
	NSArray *ubiquitousItemKeys = @[
	//NSURLIsUbiquitousItemKey,
	//NSURLUbiquitousItemHasUnresolvedConflictsKey,
	//NSURLUbiquitousItemIsDownloadedKey,
	//NSURLUbiquitousItemIsDownloadingKey,
	//NSURLUbiquitousItemIsUploadedKey,
	//NSURLUbiquitousItemIsUploadingKey,
	
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
	NSMutableDictionary *resourceValues = [[NSMutableDictionary alloc] initWithDictionary:[self resourceValuesForUbiquitousItemKeysWithError:&error]];FXDLog_ERROR;

	error = nil;
	[resourceValues setValuesForKeysWithDictionary:[self resourceValuesForKeys:nil error:&error]];FXDLog_ERROR;
	
	return resourceValues;	
}

#pragma mark -
- (NSString*)unicodeAbsoluteString {
	return [[self absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDate*)attributeModificationDate {
	
	NSDate *attributeModificationDate = nil;

	NSError *error = nil;
	//[self getResourceValue:&attributeModificationDate forKey:NSURLAttributeModificationDateKey error:&error];FXDLog_ERROR;
	[self getResourceValue:&attributeModificationDate forKey:NSURLCreationDateKey error:&error];FXDLog_ERROR;
	
	return attributeModificationDate;
}

#pragma mark -
- (FILE_KIND_TYPE)fileKindType {
	FILE_KIND_TYPE fileKindType = fileKindUndefined;

	
	NSString *typeIdentifier = nil;

	NSError *error = nil;
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
- (NSString*)fileSizeString {
	
	NSNumber *fileSize = nil;

	NSError *error = nil;
	[self getResourceValue:&fileSize forKey:NSURLFileSizeKey error:&error];FXDLog_ERROR;

	NSString *formattedString = [fileSize byteUnitFormatted];
	
	return formattedString;
}

#pragma mark -
- (double)transferPercentage {
	double transferPercentage = 0.0;

	id isTransferringObj = nil;
	[self getResourceValue:&isTransferringObj forKey:NSURLUbiquitousItemIsUploadingKey error:nil];

	if ([isTransferringObj boolValue]) {
#if ENVIRONMENT_newestSDK
#else
		NSNumber *percentage = nil;
		[self getResourceValue:&percentage forKey:NSURLUbiquitousItemPercentUploadedKey error:nil];

		transferPercentage = [percentage doubleValue];
#endif

		return transferPercentage;
	}


	isTransferringObj = nil;
	[self getResourceValue:&isTransferringObj forKey:NSURLUbiquitousItemIsDownloadingKey error:nil];

	if ([isTransferringObj boolValue]) {
#if ENVIRONMENT_newestSDK
#else
		NSNumber *percentage = nil;
		[self getResourceValue:&percentage forKey:NSURLUbiquitousItemPercentDownloadedKey error:nil];

		transferPercentage = [percentage doubleValue];
#endif
	}

	return transferPercentage;
}

@end