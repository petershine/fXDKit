

#import "FXDmoduleSearch.h"


#pragma mark - Public implementation
@implementation FXDmoduleSearch


#pragma mark - Memory management
- (void)dealloc {
	[_searchingOperationQueue cancelAllOperations];
	[_searchingOperationDictionary removeAllObjects];
	_searchingOperationDictionary = nil;
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSArray*)chosung {
	if (_chosung == nil) {
		_chosung = @[@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",
			   @"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",
			   @"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ"];
	}
	
	return _chosung;
}

- (NSArray*)jungsung {
	if (_jungsung == nil) {
		_jungsung = @[@"ㅏ",@"ㅐ",@"ㅑ",@"ㅒ",@"ㅓ",@"ㅔ",
				@"ㅕ",@"ㅖ",@"ㅗ",@"ㅘ",@"ㅙ",@"ㅚ",
				@"ㅛ",@"ㅜ",@"ㅝ",@"ㅞ",@"ㅟ",@"ㅠ",
				@"ㅡ",@"ㅢ",@"ㅣ"];
	}
	
	return _jungsung;
}

- (NSArray*)jongsung {
	if (_jongsung == nil) {
		_jongsung = @[@"",@"ㄱ",@"ㄲ",@"ㄳ",@"ㄴ",@"ㄵ",@"ㄶ",
				@"ㄷ",@"ㄹ",@"ㄺ",@"ㄻ",@"ㄼ",@"ㄽ",@"ㄾ",
				@"ㄿ",@"ㅀ",@"ㅁ",@"ㅂ",@"ㅄ",@"ㅅ",@"ㅆ",
				@"ㅇ",@"ㅈ",@"ㅊ",@"ㅋ",@" ㅌ",@"ㅍ",@"ㅎ"];
	}
	
	return _jongsung;
}


#pragma mark -
- (NSOperationQueue*)searchingOperationQueue {
	if (_searchingOperationQueue == nil) {
		_searchingOperationQueue = [NSOperationQueue newSerialQueue];
	}
	
	return _searchingOperationQueue;
}

- (NSMutableDictionary*)searchingOperationDictionary {
	if (_searchingOperationDictionary == nil) {
		_searchingOperationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return _searchingOperationDictionary;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)startSearchWithSearchString:(NSString*)searchString withDidFinishBlock:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT
	
	FXDLogVariable(self.searchingOperationQueue.operationCount);
	FXDLog(@"1.%@", _Variable(self.searchingOperationDictionary.count));

	for (NSString *key in [self.searchingOperationDictionary allKeys]) {
		
		if ([key isEqualToString:searchString] == NO) {
			NSBlockOperation *queuedOperation = self.searchingOperationDictionary[key];
			[self.searchingOperationDictionary removeObjectForKey:key];
			
			[queuedOperation cancel];
			FXDLog(@"%@ %@ %@", _Object(queuedOperation), _BOOL(queuedOperation.isCancelled), _Object(key));
		}
	}
	
	FXDLog(@"2.%@", _Variable(self.searchingOperationDictionary.count));
	
	
	__block NSArray *filteredArray = nil;
	
	NSBlockOperation *searchOperation = [[NSBlockOperation alloc] init];
	__weak NSBlockOperation *weakOperation = searchOperation;
	
	[searchOperation addExecutionBlock:^{

		/*
		PWDmanagerCoreData *coreDataManager = [PWDmanagerCoreData sharedInstance];
		
		FXDFetchedResultsController *resultsController =
		[coreDataManager.mainDocument.managedObjectContext
		 resultsControllerForEntityName:coreDataManager.mainEntityName
		 withSortDescriptors:coreDataManager.mainSortDescriptors
		 withPredicate:nil
		 withLimit:limitInfiniteFetch];
		 */

		NSFetchedResultsController *resultsController = nil;
		
		if (weakOperation && weakOperation.isCancelled == NO) {
			NSArray *fetchedObjArray = [resultsController.fetchedObjects copy];
			FXDLogVariable(fetchedObjArray.count);
			
			if (weakOperation && weakOperation.isCancelled == NO) {
				NSPredicate *searchPredicate = [self predicateWithSearchString:searchString];
				filteredArray = [fetchedObjArray filteredArrayUsingPredicate:searchPredicate];
			
				if (weakOperation && weakOperation.isCancelled == NO) {
					NSArray *searchSortDescriptors = [self sortDescriptorsForSearch];
					filteredArray = [filteredArray sortedArrayUsingDescriptors:searchSortDescriptors];
				}
				
				FXDLogVariable(filteredArray.count);
			}
		}
		
		
		[[NSOperationQueue mainQueue]
		 addOperationWithBlock:^{
			if (weakOperation && weakOperation.isCancelled == NO) {
				self->_searchedObjArray = nil;
				self->_searchedObjArray = [filteredArray mutableCopy];
			}
			
			BOOL finished = (weakOperation && weakOperation.isCancelled == NO);
			
			FXDLog(@"%@ %@", _BOOL(finished), _Variable(self.searchedObjArray.count));
			
			if (finishCallback) {
				finishCallback(_cmd, finished, nil);
			}
		}];
	}];
	
	
	self.searchingOperationDictionary[searchString] = searchOperation;
	
	[self.searchingOperationQueue addOperation:searchOperation];
}

- (void)cancelSearchWithDidFinishBlock:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT
	FXDLogVariable(self.searchingOperationQueue.operationCount);
	
	if ([self.searchingOperationQueue operationCount] > 0) {
		[self.searchingOperationQueue cancelAllOperations];
	}
	
	[_searchedObjArray removeAllObjects];
	_searchedObjArray = nil;
	
	if (finishCallback) {
		finishCallback(_cmd, YES, nil);
	}
}

#pragma mark -
- (void)deleteSearchedObj:(id)searchedObj {	FXDLog_DEFAULT
	FXDLog(@"1.%@", _Variable(_searchedObjArray.count));
	[_searchedObjArray removeObject:searchedObj];
	FXDLog(@"2.%@", _Variable(_searchedObjArray.count));
}

#pragma mark -
- (NSPredicate*)predicateWithSearchString:(NSString*)searchString {
	
	if ([searchString length] == 0) {
		return nil;
	}
	
	
	NSString *chosungString = [self chosungFromNormalKorean:searchString];
	
	//MARK: If searchString itself is chosung...
	if ([chosungString length] == 0) {
		chosungString = searchString;
	}
	else {
		chosungString = nil;
	}
	
	FXDLog(@"%@ %@", _Object(searchString), _Object(chosungString));
	
	NSString *encryptionKey = nil;
	
	NSPredicate *predicate =
	[NSPredicate
	 predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		 
		 //MARK: Use nil for normal strings
		 if ([self findSearchString:searchString
					orChosungString:chosungString
				 usingEncryptionKey:nil
				  fromEncryptedText:nil]) {
			 return YES;
		 }
		 
		 
		 if ([self findSearchString:searchString
					orChosungString:chosungString
				 usingEncryptionKey:encryptionKey
				  fromEncryptedText:nil]) {
			 return YES;
		 }
		 

		 /*
		 if ([self findSearchString:searchString
					orChosungString:chosungString
				 usingEncryptionKey:encryptionKey
				  fromEncryptedText:loginItemObj.loginPassword]) {
			 return YES;
		 }
		  */
		 
		 
		 if ([self findSearchString:searchString
					orChosungString:chosungString
				 usingEncryptionKey:encryptionKey
				  fromEncryptedText:nil]) {
			 return YES;
		 }
		 
		 return NO;
	 }];
	
	return  predicate;
}

- (NSArray*)sortDescriptorsForSearch {
	return nil;
}

#pragma mark -
- (BOOL)findSearchString:(NSString*)searchString orChosungString:(NSString*)chosungString usingEncryptionKey:encryptionKey fromEncryptedText:(NSString*)encryptedText {
	
	NSString *sourceText = encryptedText;

	/*
	if (encryptionKey) {
		sourceText = [AESCrypt decrypt:encryptedText password:encryptionKey];
	}
	 */
	
	if ([self searchString:searchString fromSourceText:sourceText]) {
		return YES;
	}
	
	
	NSString *chosungText = nil;

	BOOL didFind = NO;

	if (chosungString.length > 0) {
		chosungText = [self chosungFromNormalKorean:sourceText];
		
		if (chosungText.length > 0) {
			didFind = [self searchString:chosungString fromSourceText:chosungText];
		}
	}

	//FXDLog(@"%@ %@", _BOOL(didFind), _Object(chosungText));
	
	return didFind;
}

- (BOOL)searchString:(NSString*)string fromSourceText:(NSString*)sourceText {
	BOOL didFind = NO;
	
	NSRange range = [sourceText rangeOfString:string options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
	
	if (range.length > 0) {
		//FXDLog(@"FOUND %@ in: %@", NSStringFromRange(range), sourceText);
		didFind = YES;
	}
	
	return didFind;
}

#pragma mark -
- (NSString*)chosungFromNormalKorean:(NSString*)normalKorean {
	NSMutableString *result = [NSMutableString string];
	
    for (NSUInteger i = 0; i < [normalKorean length]; i++) {
        NSInteger unicodeChar = [normalKorean characterAtIndex:i];
		
        if (HANGUL_START_CODE <= unicodeChar && unicodeChar <= HANGUL_END_CODE ) {
            NSInteger chosungIndex  = (NSInteger)((unicodeChar - HANGUL_START_CODE) / (28*21));
            //NSInteger jungsungIndex = (NSInteger)((unicodeChar - HANGUL_START_CODE) % (28*21) / 28);
            //NSInteger jongsungIndex = (NSInteger)((unicodeChar - HANGUL_START_CODE) % 28);
			
			if (chosungIndex < [self.chosung count]) {
				[result appendFormat:@"%@", (self.chosung)[chosungIndex]];
			}
        }
    }
	
	//TODO: Compare the length with the original texts
	
    return result;
}

- (NSString*)jungsungFromNormalKorean:(NSString*)normalKorean {
	NSMutableString *result = [NSMutableString string];
	
    for (NSUInteger i = 0; i < [normalKorean length]; i++) {
        NSInteger unicodeChar = [normalKorean characterAtIndex:i];
		
        if (HANGUL_START_CODE <= unicodeChar && unicodeChar <= HANGUL_END_CODE ) {
			NSInteger jungsungIndex = (NSInteger)((unicodeChar - HANGUL_START_CODE) % (28*21) / 28);
			
			if (jungsungIndex < [self.jungsung count]) {
				[result appendFormat:@"%@", (self.jungsung)[jungsungIndex]];
			}
        }
    }
	
	//TODO: Compare the length with the original texts
	
    return result;
}

- (NSString*)jongsungFromNormalKorean:(NSString*)normalKorean {
	NSMutableString *result = [NSMutableString string];
	
    for (NSUInteger i = 0; i < [normalKorean length]; i++) {
        NSInteger unicodeChar = [normalKorean characterAtIndex:i];
		
        if (HANGUL_START_CODE <= unicodeChar && unicodeChar <= HANGUL_END_CODE ) {
			NSInteger jongsungIndex = (NSInteger)((unicodeChar - HANGUL_START_CODE) % 28);
			
			if (jongsungIndex < [self.jongsung count]) {
				[result appendFormat:@"%@", (self.jongsung)[jongsungIndex]];
			}
        }
    }
	
    return result;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
