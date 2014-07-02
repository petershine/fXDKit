//
//  FXDManagedDocument.m
//
//
//  Created by petershine on 7/25/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDManagedDocument.h"



@implementation FXDManagedDocument


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
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
	FXDdocLog(@"%@, %@", _Object(url), _Variable(saveOperation));
	
	[super saveToURL:url forSaveOperation:saveOperation completionHandler:completionHandler];
}

#pragma mark -
- (id)changeCountTokenForSaveOperation:(UIDocumentSaveOperation)saveOperation {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@", _Variable(saveOperation));
	
	id changeCountToken = [super changeCountTokenForSaveOperation:saveOperation];
	FXDdocLog(@"%@", _Object(changeCountToken));
	
	return changeCountToken;
}

- (void)updateChangeCountWithToken:(id)changeCountToken forSaveOperation:(UIDocumentSaveOperation)saveOperation {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@ %@", _Object(changeCountToken), _Variable(saveOperation));

	[super updateChangeCountWithToken:changeCountToken forSaveOperation:saveOperation];
}

#pragma mark -
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@ %@", _Object(contents), _Object(typeName));
	
	BOOL didLoad = [super loadFromContents:contents ofType:typeName error:outError];
	FXDdocLog(@"%@", _BOOL(didLoad));
	
	return didLoad;
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@", _Object(typeName));
	
	id contents = [super contentsForType:typeName error:outError];
	FXDdocLog(@"%@", _Object(contents));
	
	return contents;
}

#pragma mark -
- (BOOL)hasUnsavedChanges {	FXDdocLog_DEFAULT;
	BOOL hasUnsavedChanges = [super hasUnsavedChanges];
	FXDdocLog(@"%@", _BOOL(hasUnsavedChanges));
	
	return hasUnsavedChanges;
}

- (void)updateChangeCount:(UIDocumentChangeKind)change {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@", _Variable(change));

	[super updateChangeCount:change];
}

#pragma mark -
- (NSString *)savingFileType {	FXDdocLog_DEFAULT;
	NSString *fileType = [super savingFileType];
	FXDdocLog(@"%@", _Object(fileType));
	
	return fileType;
}

- (NSString *)fileNameExtensionForType:(NSString *)typeName saveOperation:(UIDocumentSaveOperation)saveOperation {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@ %@", _Object(typeName), _Variable(saveOperation));
	
	NSString *fileName = [super fileNameExtensionForType:typeName saveOperation:saveOperation];
	FXDdocLog(@"%@", _Object(fileName));
	
	return fileName;
}

#pragma mark -
- (BOOL)writeContents:(id)contents andAttributes:(NSDictionary *)additionalFileAttributes safelyToURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@ %@ %@ %@", _Object(contents), _Object(additionalFileAttributes), _Object(url), _Variable(saveOperation));
	
	BOOL didWrite = [super writeContents:contents andAttributes:additionalFileAttributes safelyToURL:url forSaveOperation:saveOperation error:outError];
	FXDdocLog(@"%@", _BOOL(didWrite));
	
	return didWrite;
}

- (BOOL)writeContents:(id)contents toURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation originalContentsURL:(NSURL *)originalContentsURL error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@ %@ %@ %@", _Object(contents), _Object(url), _Variable(saveOperation), _Object(originalContentsURL));
	
	BOOL didWrite = [super writeContents:contents toURL:url forSaveOperation:saveOperation originalContentsURL:originalContentsURL error:outError];
	FXDdocLog(@"%@", _BOOL(didWrite));
	
	return didWrite;
}

- (NSDictionary *)fileAttributesToWriteToURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@ %@", _Object(url), _Variable(saveOperation));
	
	NSDictionary *fileAttributes = [super fileAttributesToWriteToURL:url forSaveOperation:saveOperation error:outError];
	FXDdocLog(@"%@", _Object(fileAttributes));
	
	return fileAttributes;
}

- (BOOL)readFromURL:(NSURL *)url error:(NSError **)outError {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@", _Object(url));
	
	BOOL didRead = [super readFromURL:url error:outError];
	FXDdocLog(@"%@", _BOOL(didRead));
	
	return didRead;
}

#pragma mark -
- (void)performAsynchronousFileAccessUsingBlock:(void (^)(void))block {	FXDLog_DEFAULT;
	[super performAsynchronousFileAccessUsingBlock:block];
}

#pragma mark -
- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@, %@", _Object(error), _BOOL(userInteractionPermitted));
	
	[super handleError:error userInteractionPermitted:userInteractionPermitted];
}

- (void)finishedHandlingError:(NSError *)error recovered:(BOOL)recovered {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@, %@", _Object(error), _BOOL(recovered));

	[super finishedHandlingError:error recovered:recovered];
}

- (void)userInteractionNoLongerPermittedForError:(NSError *)error {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@", _Object(error));

	[super userInteractionNoLongerPermittedForError:error];
}

#pragma mark -
- (void)revertToContentsOfURL:(NSURL *)url completionHandler:(void (^)(BOOL success))completionHandler {	FXDdocLog_DEFAULT;
	FXDdocLog(@"%@", _Object(url));

	[super revertToContentsOfURL:url completionHandler:completionHandler];
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
