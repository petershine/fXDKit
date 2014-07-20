

#import "FXDManagedDocument.h"


@implementation FXDManagedDocument

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSManagedObjectModel*)managedObjectModel {	FXDLog_DEFAULT;
	FXDLogObject(self.MOMDfilename);

	if (self.MOMDfilename.length == 0) {
		return [super managedObjectModel];
	}


#warning	//MARK: Make sure merging is done correctly manually
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *modelPath = [bundle pathForResource:self.MOMDfilename ofType:@"momd"];

	NSManagedObjectModel *mainModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];

	return mainModel;
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
