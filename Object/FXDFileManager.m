

#import "FXDFileManager.h"


@implementation NSFileManager (Essential)
- (NSString*)prepareDirectoryAtPath:(NSString *)directoryPath withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError **)error {	FXDLog_DEFAULT;

	FXDLogObject(directoryPath);

	BOOL isDirectory = NO;
	if ([self fileExistsAtPath:directoryPath isDirectory:&isDirectory]) {
		FXDLogBOOL(isDirectory);

		if (isDirectory) {
			return directoryPath;
		}
	}


	BOOL didCreate = [self
					  createDirectoryAtPath:directoryPath
					  withIntermediateDirectories:createIntermediates
					  attributes:attributes
					  error:error];
	FXDLogBOOL(didCreate);

	return (didCreate) ? directoryPath : nil;
}

#pragma mark -
- (void)clearTempDirectory {	FXDLog_DEFAULT;
	[self clearDirectory:NSTemporaryDirectory()];
}

- (void)clearDirectory:(NSString*)directory {	FXDLog_DEFAULT;
	FXDLogObject(directory);
	
	NSError *error = nil;
	NSArray *clearedFileArray = [self contentsOfDirectoryAtPath:directory error:&error];
	FXDLog_ERROR;

	FXDLogObject(clearedFileArray);

	for (NSString *clearedFilePath in clearedFileArray) {
		NSError *error = nil;
		[self removeItemAtPath:[directory stringByAppendingPathComponent:clearedFilePath] error:&error];
		FXDLog_ERROR;
	}
}

#pragma mark -
- (NSDirectoryEnumerator*)fullEnumeratorForRootURL:(NSURL*)rootURL {
	
	NSDirectoryEnumerator *fullEnumerator =
	[self
	 enumeratorAtURL:rootURL
	 includingPropertiesForKeys:nil
	 options:0
	 errorHandler:^BOOL(NSURL *url, NSError *error) {	FXDLog_DEFAULT;
		 FXDLog_ERROR;
		 FXDLogObject(url);

		 return YES;
	 }];

	return fullEnumerator;
}

- (NSDirectoryEnumerator*)limitedEnumeratorForRootURL:(NSURL*)rootURL {
	
	NSDirectoryEnumerator *limitedEnumerator =
	[self
	 enumeratorAtURL:rootURL
	 includingPropertiesForKeys:nil
	 options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsPackageDescendants
	 errorHandler:^BOOL(NSURL *url, NSError *error) {	FXDLog_DEFAULT;
		 FXDLog_ERROR;
		 FXDLogObject(url);

		 return YES;
	 }];

	return limitedEnumerator;
}

- (NSMutableDictionary*)infoDictionaryForFolderURL:(NSURL*)folderURL {
	
	if (folderURL == nil) {
		return nil;
	}


	NSMutableDictionary *infoDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	infoDictionary[@"folderName"] = folderURL.lastPathComponent;
	
	
	NSDirectoryEnumerator *enumerator = [self limitedEnumeratorForRootURL:folderURL];
	
	NSMutableArray *itemArray = nil;
	
	NSURL *nextURL = [enumerator nextObject];
	
	while (nextURL) {
		
		id isDirectory = nil;

		NSError *error = nil;
		[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
		FXDLog_ERROR;
		
		if ([isDirectory boolValue]) {	//NOTE: recursively called
			NSMutableDictionary *subInfoDictionary = [self infoDictionaryForFolderURL:nextURL];
			
			if (subInfoDictionary && subInfoDictionary.count > 0) {
				if (itemArray == nil) {
					itemArray = [[NSMutableArray alloc] initWithCapacity:0];
				}
				
				[itemArray addObject:subInfoDictionary];
			}
		}
		else {
			if (itemArray == nil) {
				itemArray = [[NSMutableArray alloc] initWithCapacity:0];
			}
			
			[itemArray addObject:nextURL.lastPathComponent];
		}
		
		nextURL = [enumerator nextObject];
	}
	
	if (itemArray && itemArray.count > 0) {
		infoDictionary[@"items"] = itemArray;
	}
	
	return infoDictionary;
}

#pragma mark -
- (void)setUbiquitousForLocalItemURLarray:(NSArray*)localItemURLarray atFolderURL:(NSURL*)folderURL {	FXDLog_DEFAULT;
	FXDLogObject(folderURL);

	if (folderURL == nil) {
		return;
	}


	for (NSURL *itemURL in localItemURLarray) {
		NSString *localItemPath = itemURL.lastPathComponent;

		NSURL *destinationURL = folderURL;

		if (localItemPath.length > 0) {
			destinationURL = [destinationURL URLByAppendingPathComponent:localItemPath];
		}


		NSError *error = nil;
		BOOL didSetUbiquitous = [self setUbiquitous:YES itemAtURL:itemURL destinationURL:destinationURL error:&error];

		FXDLog(@"%@ %@ %@", _BOOL(didSetUbiquitous), _Object(itemURL), _Object(destinationURL));

		if (error || didSetUbiquitous == NO) {
			[self handleFailedLocalItemURL:itemURL withDestinationURL:destinationURL withResultError:error];
		}
	}
}

- (void)handleFailedLocalItemURL:(NSURL*)localItemURL withDestinationURL:(NSURL*)destinationURL withResultError:(NSError*)resultError {	//FXDLog_DEFAULT;

	/*
	 domain: NSCocoaErrorDomain
	 code: 516
	 localizedDescription: The operation couldn’t be completed. (Cocoa error 516.)
	 userInfo: {
	 NSFilePath = "/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~fXceed~EasyFileSharing/Documents/EasyFileSharing_1.1_0710.pdf";
	 NSUnderlyingError = "Error Domain=NSPOSIXErrorDomain Code=17 \"The operation couldn\U2019t be completed. File exists\"";
	 }

	 domain: NSCocoaErrorDomain
	 code: 260
	 localizedDescription: The operation couldn’t be completed. (Cocoa error 260.)
	 userInfo: {
	 NSFilePath = "/private/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Documents/IMG_1144.JPG";
	 NSURL = "file://localhost/private/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Documents/IMG_1144.JPG";
	 NSUnderlyingError = "Error Domain=NSPOSIXErrorDomain Code=2 \"The operation couldn\U2019t be completed. No such file or directory\" UserInfo=0xf89ddd0 {}";
	 }

	 domain: NSPOSIXErrorDomain
	 code: 2
	 localizedDescription: The operation couldn’t be completed. No such file or directory
	 userInfo: {
	 NSDescription = "Unable to rename '/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Library/Caches/IMG_1349.JPG' to '/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~fXceed~EasyFileSharing/Documents/file://localhost/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Library/Caches/IMG_1349.JPG'.";
	 }

	 2012-08-16 10:35:19.251 EasyFileSharing[21409:15b03] [EFScontrolCaches addNewThumbImage:toCachedURL:]
	 localizedDescription: The operation couldn’t be completed. (LibrarianErrorDomain error 2 - Cannot enable syncing on a synced item.)
	 domain: LibrarianErrorDomain code: 2
	 userInfo:
	 {
	 NSDescription = "Cannot enable syncing on a synced item.";
	 }
	 */


	NSString *alertTitle = nil;

	if ([resultError.domain isEqualToString:NSPOSIXErrorDomain]) {
		switch (resultError.code) {
			case 63:	//The operation couldn’t be completed. File name too long
				break;

			default:
				break;
		}
	}
	else if ([resultError.domain isEqualToString:NSCocoaErrorDomain]) {
		switch (resultError.code) {
			case 516:	{
				//"Error Domain=NSPOSIXErrorDomain Code=17 \"The operation couldn\U2019t be completed. File exists\"";
				NSError *error = nil;
				[[NSFileManager defaultManager] removeItemAtURL:localItemURL error:&error];FXDLog_ERROR;
			}	break;

			default:
				alertTitle = [NSString stringWithFormat:@"%@\n%@", resultError.localizedDescription, localItemURL];
				break;
		}
	}

	if (alertTitle) {	FXDLog_DEFAULT;
		FXDLogObject(alertTitle);
		//FIXME: Handle error with alert of notification
	}
}

@end
