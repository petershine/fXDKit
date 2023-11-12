

#import "FXDmoduleCoredata.h"


@implementation FXDmoduleCoredata

#pragma mark - Memory management
- (void)dealloc {
	[_enumeratingOperationQueue cancelAllOperations];
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSOperationQueue*)enumeratingOperationQueue {
	if (_enumeratingOperationQueue == nil) {
		_enumeratingOperationQueue = [NSOperationQueue newSerialQueueWithName:NSStringFromSelector(_cmd)];
	}
	return _enumeratingOperationQueue;
}

#pragma mark -
- (NSString*)coredataName {
	if (_coredataName == nil) {
		_coredataName = application_BundleIdentifier;

		FXDLog_OVERRIDE;
		FXDLogObject(_coredataName);
	}

	return _coredataName;
}

- (NSString*)ubiquitousContentName {
	if (_ubiquitousContentName == nil) {
		_ubiquitousContentName = [self.coredataName stringByReplacingOccurrencesOfString:@"." withString:@"_"];

		FXDLog_OVERRIDE;
		FXDLogObject(_ubiquitousContentName);
	}

	return _ubiquitousContentName;
}

- (NSString*)sqlitePathComponent {
	
	//MARK: Use different name for better controlling between developer build and release build
	if (_sqlitePathComponent == nil) {
		_sqlitePathComponent = [NSString stringWithFormat:@"%@.sqlite", self.coredataName];

	#if DEBUG
		_sqlitePathComponent = [NSString stringWithFormat:@"DEV_%@.sqlite", self.coredataName];
	#endif

		FXDLog_OVERRIDE;
		FXDLogObject(_sqlitePathComponent);
	}
	
	return _sqlitePathComponent;
}

#pragma mark -
- (NSString*)mainEntityName {
	if (_mainEntityName == nil) {	FXDLog_OVERRIDE;
		//SAMPLE: _mainEntityName = entityname<#DefaultClass#>
	}
	return _mainEntityName;
}

- (NSArray*)mainSortDescriptors {
	if (_mainSortDescriptors == nil) {	FXDLog_OVERRIDE;
		//SAMPLE: _mainSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attribkey<#AttributeName#> ascending:<#NO#>]];
	}
	return _mainSortDescriptors;
}


#pragma mark - Method overriding

#pragma mark - Public
- (BOOL)doesStoredSqliteExist {	FXDLog_DEFAULT
	NSString *storedPath = [appSearchPath_Document stringByAppendingPathComponent:self.sqlitePathComponent];
	FXDLogObject(storedPath);

	BOOL storedSqliteExists = [[NSFileManager defaultManager] fileExistsAtPath:storedPath];
	FXDLogBOOL(storedSqliteExists);

	return storedSqliteExists;
}


@end
