//
//  FXDManagedDocument.m
//
//
//  Created by petershine on 7/25/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDManagedDocument.h"


#pragma mark - Public implementation
@implementation FXDManagedDocument


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
    //TODO:
}


#pragma mark - Initialization

#pragma mark - Property overriding

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
	FXDLog(@"%@, %@", strObject(url), strVariable(saveOperation));
	
	[super saveToURL:url forSaveOperation:saveOperation completionHandler:completionHandler];
}


#if TEST_loggingManagedDocumentAutoSaving
#pragma mark -
- (id)changeCountTokenForSaveOperation:(UIDocumentSaveOperation)saveOperation {	FXDdocLog_DEFAULT;
	FXDdocLog(@"saveOperation: %d", saveOperation);
	
	id changeCountToken = [super changeCountTokenForSaveOperation:saveOperation];
	FXDdocLog(@"changeCountToken: %@", changeCountToken);
	
	return changeCountToken;
}

- (void)updateChangeCountWithToken:(id)changeCountToken forSaveOperation:(UIDocumentSaveOperation)saveOperation {	FXDdocLog_DEFAULT;
	FXDdocLog(@"changeCountToken: %@, saveOperation: %d", changeCountToken, saveOperation);
	[super updateChangeCountWithToken:changeCountToken forSaveOperation:saveOperation];
}

#pragma mark -
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"contents: %@, typeName: %@, *outError: %@", contents, typeName, *outError);
	
	BOOL didLoad = [super loadFromContents:contents ofType:typeName error:outError];
	FXDdocLog(@"didLoad: %d", didLoad);
	
	return didLoad;
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"typeName: %@, *outError: %@", typeName, *outError);
	
	id contents = [super contentsForType:typeName error:outError];
	FXDdocLog(@"contents: %@", contents);
	
	return contents;
}

#pragma mark -
- (BOOL)hasUnsavedChanges {	FXDdocLog_DEFAULT;
	BOOL hasUnsavedChanges = [super hasUnsavedChanges];
	FXDdocLog(@"hasUnsavedChanges: %d", hasUnsavedChanges);
	
	return hasUnsavedChanges;
}

- (void)updateChangeCount:(UIDocumentChangeKind)change {	FXDdocLog_DEFAULT;
	FXDdocLog(@"change: %d", change);
	[super updateChangeCount:change];
}

#pragma mark -
- (NSString *)savingFileType {	FXDdocLog_DEFAULT;
	NSString *fileType = [super savingFileType];
	FXDdocLog(@"fileType: %@", fileType);
	
	return fileType;
}

- (NSString *)fileNameExtensionForType:(NSString *)typeName saveOperation:(UIDocumentSaveOperation)saveOperation {	FXDdocLog_DEFAULT;
	FXDdocLog(@"typeName: %@, saveOperation: %d", typeName, saveOperation);
	
	NSString *fileName = [super fileNameExtensionForType:typeName saveOperation:saveOperation];
	FXDdocLog(@"fileName: %@", fileName);
	
	return fileName;
}

#pragma mark -
- (BOOL)writeContents:(id)contents andAttributes:(NSDictionary *)additionalFileAttributes safelyToURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"contents: %@ additionalFileAttributes: %@ url: %@ saveOperation: %d *outError: %@", contents, additionalFileAttributes, url, saveOperation, *outError);
	
	BOOL didWrite = [super writeContents:contents andAttributes:additionalFileAttributes safelyToURL:url forSaveOperation:saveOperation error:outError];
	FXDdocLog(@"didWrite: %d", didWrite);
	
	return didWrite;
}

- (BOOL)writeContents:(id)contents toURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation originalContentsURL:(NSURL *)originalContentsURL error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"contents: %@ url: %@ saveOperation: %d originalContentsURL: %@ *outError: %@", contents, url, saveOperation, originalContentsURL, *outError);
	
	BOOL didWrite = [super writeContents:contents toURL:url forSaveOperation:saveOperation originalContentsURL:originalContentsURL error:outError];
	FXDdocLog(@"didWrite: %d", didWrite);
	
	return didWrite;
}

- (NSDictionary *)fileAttributesToWriteToURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"url: %@ saveOperation: %d *outError: %@", url, saveOperation, *outError);
	
	NSDictionary *fileAttributes = [super fileAttributesToWriteToURL:url forSaveOperation:saveOperation error:outError];
	FXDdocLog(@"fileAttributes: %@", fileAttributes);
	
	return fileAttributes;
}

- (BOOL)readFromURL:(NSURL *)url error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"url: %@, outError: %@", url, *outError);
	
	BOOL didRead = [super readFromURL:url error:outError];
	FXDdocLog(@"didRead: %d", didRead);
	
	return didRead;
}

#pragma mark -
- (void)performAsynchronousFileAccessUsingBlock:(void (^)(void))block {	FXDLog_DEFAULT;
	[super performAsynchronousFileAccessUsingBlock:block];
}

#pragma mark -
- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {	FXDdocLog_DEFAULT;
	FXDLog(@"%@, %@", strObject(error), strBOOL(userInteractionPermitted));
	[super handleError:error userInteractionPermitted:userInteractionPermitted];
}

- (void)finishedHandlingError:(NSError *)error recovered:(BOOL)recovered {	FXDdocLog_DEFAULT;
	FXDLog(@"%@, %@", strObject(error), strBOOL(recovered));
	[super finishedHandlingError:error recovered:recovered];
}

- (void)userInteractionNoLongerPermittedForError:(NSError *)error {	FXDdocLog_DEFAULT;
	FXDdocLog(@"error: %@", error);
	[super userInteractionNoLongerPermittedForError:error];
}

#pragma mark -
- (void)revertToContentsOfURL:(NSURL *)url completionHandler:(void (^)(BOOL success))completionHandler {	FXDdocLog_DEFAULT;
	FXDdocLog(@"url: %@", url);
	[super revertToContentsOfURL:url completionHandler:completionHandler];
}

#endif

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
