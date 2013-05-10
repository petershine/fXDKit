//
//  FXDManagedDocument.m
//  PhotoAlbum
//
//  Created by petershine on 5/10/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//
#import "FXDManagedDocument.h"


#pragma mark - Public implementation
@implementation FXDManagedDocument


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)autosaveWithCompletionHandler:(void (^)(BOOL success))completionHandler {	FXDLog_DEFAULT;
	FXDLog(@"self hasUnsavedChanges: %d", [self hasUnsavedChanges]);
	FXDLog(@"self.managedObjectContext hasChanges: %d", [self.managedObjectContext hasChanges]);
	FXDLog(@"self.managedObjectContext.parentContext hasChanges: %d", [self.managedObjectContext.parentContext hasChanges]);
	
	[super autosaveWithCompletionHandler:completionHandler];
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
