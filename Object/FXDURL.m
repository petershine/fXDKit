

#import "FXDURL.h"


@implementation NSURL (Essential)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error {
	NSArray *ubiquitousItemKeys =
	@[NSURLIsUbiquitousItemKey,
	  NSURLUbiquitousItemHasUnresolvedConflictsKey,

	  NSURLUbiquitousItemDownloadingStatusKey,

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
	NSMutableDictionary *resourceValues = [[NSMutableDictionary alloc] initWithDictionary:[self resourceValuesForUbiquitousItemKeysWithError:&error]];
	FXDLog_ERROR;


	NSArray *resourceKeys =
	@[NSURLNameKey,
	  NSURLLocalizedNameKey,

	  NSURLIsRegularFileKey,
	  NSURLIsDirectoryKey,
	  NSURLIsSymbolicLinkKey,
	  NSURLIsVolumeKey,
	  NSURLIsPackageKey,

	  NSURLIsSystemImmutableKey,
	  NSURLIsUserImmutableKey,
	  NSURLIsHiddenKey,

	  NSURLHasHiddenExtensionKey,

	  NSURLCreationDateKey,
	  NSURLContentAccessDateKey,
	  NSURLContentModificationDateKey,
	  NSURLAttributeModificationDateKey,

	  NSURLLinkCountKey,
	  NSURLParentDirectoryURLKey,
	  NSURLVolumeURLKey,

	  NSURLTypeIdentifierKey,
	  NSURLLocalizedTypeDescriptionKey,

	  NSURLFileResourceIdentifierKey,
	  NSURLVolumeIdentifierKey,
	  NSURLPreferredIOBlockSizeKey,

	  NSURLIsReadableKey,
	  NSURLIsWritableKey,
	  NSURLIsExecutableKey,
	  NSURLFileSecurityKey,
	  NSURLIsExcludedFromBackupKey,

	  NSURLPathKey,

	  NSURLFileResourceTypeKey,

	  NSURLFileSizeKey,
	  NSURLFileAllocatedSizeKey,
	  NSURLTotalFileSizeKey,
	  NSURLTotalFileAllocatedSizeKey,

	  NSURLIsAliasFileKey,
	  ];

	error = nil;
	[resourceValues setValuesForKeysWithDictionary:[self resourceValuesForKeys:resourceKeys error:&error]];
	FXDLog_ERROR;
	
	return [resourceValues copy];
}

- (NSString*)unicodeAbsoluteString {

	NSString *unicodeString = nil;

	unicodeString = (self.absoluteString).stringByRemovingPercentEncoding;

	return unicodeString;
}

- (NSDate*)attributeModificationDate {
	
	NSDate *attributeModificationDate = nil;

	NSError *error = nil;
	[self getResourceValue:&attributeModificationDate forKey:NSURLAttributeModificationDateKey error:&error];
	FXDLog_ERROR;
	
	return attributeModificationDate;
}

- (FILE_KIND_TYPE)fileKindType {
	FILE_KIND_TYPE fileKindType = fileKindUndefined;

	NSString *typeIdentifier = nil;

	NSError *error = nil;
	[self getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:&error];
	FXDLog_ERROR_ignored(260);
	
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

- (NSString*)followingPathAfterPathComponent:(NSString *)pathComponent {
	return [self.unicodeAbsoluteString componentsSeparatedByString:pathComponent].lastObject;
}

- (NSString*)followingPathInDocuments {
	return [self followingPathAfterPathComponent:pathcomponentDocuments];
}

- (NSString*)fileSizeString {
	NSNumber *fileSize = nil;

	NSError *error = nil;
	[self getResourceValue:&fileSize forKey:NSURLFileSizeKey error:&error];
	FXDLog_ERROR;

	NSString *formattedString = fileSize.byteUnitFormatted;
	
	return formattedString;
}

#pragma mark -
+ (BOOL)validateURL:(NSString*)candidate {

	// Empty strings should return NO
	if (candidate.length == 0) {
		return NO;
	}


	NSError *error = nil;
	NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];

	if (dataDetector == nil || error) {
		FXDLogObject(dataDetector);
		FXDLog_ERROR;
		return NO;
	}


	NSRange range = NSMakeRange(0, candidate.length);
	NSRange notFoundRange = (NSRange){NSNotFound, 0};
	NSRange linkRange = [dataDetector rangeOfFirstMatchInString:candidate options:0 range:range];

	if (NSEqualRanges(notFoundRange, linkRange) || NSEqualRanges(range, linkRange) == NO) {
		FXDLogBOOL(NSEqualRanges(notFoundRange, linkRange));
		FXDLogBOOL(NSEqualRanges(range, linkRange));
		return NO;
	}


	return YES;
}

+ (BOOL)isHTTPcompatible:(NSString*)candidate {
	NSRange rangeForHTTP = [candidate rangeOfString:@"http:" options:NSCaseInsensitiveSearch];
	NSRange rangeForHTTPS = [candidate rangeOfString:@"https:" options:NSCaseInsensitiveSearch];
	//FXDLog(@"%@ %@", _Object(NSStringFromRange(rangeForHTTP)), _Object(NSStringFromRange(rangeForHTTPS)));

	//MARK: Make sure string starts with http | https
	BOOL isHTTPcompatible = ((rangeForHTTP.location == 0 && rangeForHTTP.length > 0)
							 || (rangeForHTTPS.location == 0 && rangeForHTTPS.length > 0));

	return isHTTPcompatible;
}

#pragma mark -
+ (NSURL*)evaluatedURLforPath:(NSString*)requestPath {

	requestPath = [requestPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	NSURL *evaluatedURL = [self URLWithString:requestPath];

	if (evaluatedURL) {
		//FXDLogObject(evaluatedURL);
		return evaluatedURL;
	}


	FXDLog(@"INCORRECT %@", _Object(requestPath));
	NSArray *componentArray = [requestPath componentsSeparatedByString:@"%"];

	if (componentArray.count < 2) {
		requestPath = [requestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

		evaluatedURL = [self URLWithString:requestPath];

		FXDLogObject(evaluatedURL);
		return evaluatedURL;
	}


	FXDLog(@"%@", @"NOTE: Because the percent (\"%\") character serves as the indicator for percent-encoded octets, it must be percent-encoded as \"%25\" for that octet to be used as data within a URI.");

	FXDLogVariable(componentArray.count);

	NSString *wholeEscaped = @"";

	for (NSString *component in componentArray) {

		if (component != componentArray.firstObject) {
			wholeEscaped = [wholeEscaped stringByAppendingString:@"%25"];
		}


		NSString *escaped = [component stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
		FXDLog(@"%ld:\n%@\n%@", (unsigned long)[componentArray indexOfObject:component], component, escaped);

		wholeEscaped = [wholeEscaped stringByAppendingString:escaped];
	}

	requestPath = [wholeEscaped copy];

	evaluatedURL = [self URLWithString:requestPath];

	FXDLogObject(evaluatedURL);
	return evaluatedURL;
}

@end
