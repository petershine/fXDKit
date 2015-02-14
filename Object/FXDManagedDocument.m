

#import "FXDManagedDocument.h"

#import "FXDimportCore.h"


@implementation FXDManagedDocument

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSManagedObjectModel*)managedObjectModel {
	if (self.manuallyInitializedModel) {
		return self.manuallyInitializedModel;
	}

	return [super managedObjectModel];
}

#pragma mark -
- (NSManagedObjectModel*)manuallyInitializedModel {
	if (_manuallyInitializedModel == nil) {	FXDLog_OVERRIDE;
	}
	return _manuallyInitializedModel;
}


#pragma mark - Method overriding
- (void)openWithCompletionHandler:(void (^)(BOOL success))completionHandler {	FXDLog_DEFAULT;
	[super openWithCompletionHandler:completionHandler];
}

- (void)closeWithCompletionHandler:(void (^)(BOOL success))completionHandler {	FXDLog_DEFAULT;
	[super closeWithCompletionHandler:completionHandler];
}

#pragma mark -
- (void)disableEditing {	FXDLog_DEFAULT;
	[super disableEditing];
}

- (void)enableEditing {	FXDLog_DEFAULT;
	[super enableEditing];
}

#pragma mark -
- (void)autosaveWithCompletionHandler:(void (^)(BOOL success))completionHandler {	FXDLog_DEFAULT;
	[super autosaveWithCompletionHandler:completionHandler];
}

- (void)saveToURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation completionHandler:(void (^)(BOOL success))completionHandler {	FXDLog_DEFAULT;;

	[super saveToURL:url forSaveOperation:saveOperation completionHandler:completionHandler];
}

#pragma mark -
- (void)performAsynchronousFileAccessUsingBlock:(void (^)(void))block {	FXDLog_DEFAULT;
	[super performAsynchronousFileAccessUsingBlock:block];
}


#pragma mark - Public

#pragma mark - Observer

#pragma mark - Delegate

@end
