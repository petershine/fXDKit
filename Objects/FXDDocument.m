//
//  FXDDocument.m
//  PopTooUniversal
//
//  Created by petershine on 7/2/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDDocument.h"


#pragma mark - Private interface
@interface FXDDocument (Private)
@end


#pragma mark - Public implementation
@implementation FXDDocument

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
- (void)saveToURL:(NSURL *)url forSaveOperation:(UIDocumentSaveOperation)saveOperation completionHandler:(void (^)(BOOL success))completionHandler {	FXDLog_DEFAULT;
	[super saveToURL:url forSaveOperation:saveOperation completionHandler:completionHandler];
	
}

- (void)autosaveWithCompletionHandler:(void (^)(BOOL success))completionHandler {	FXDLog_DEFAULT;
	[super autosaveWithCompletionHandler:completionHandler];
	
}

#pragma mark -
- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {	FXDLog_DEFAULT;
	[super handleError:error userInteractionPermitted:userInteractionPermitted];
}

- (void)finishedHandlingError:(NSError *)error recovered:(BOOL)recovered {	FXDLog_DEFAULT;
	[super finishedHandlingError:error recovered:recovered];
	
}

- (void)userInteractionNoLongerPermittedForError:(NSError *)error {	FXDLog_DEFAULT;
	[super userInteractionNoLongerPermittedForError:error];
	
}

#pragma mark -
- (void)revertToContentsOfURL:(NSURL *)url completionHandler:(void (^)(BOOL success))completionHandler {	FXDLog_DEFAULT;
	[super revertToContentsOfURL:url completionHandler:completionHandler];
	
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIDocument (Added)
@end
