//
//  FXDManagedDocument.h
//
//
//  Created by petershine on 7/25/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#ifndef TEST_loggingManagedDocumentAutoSaving
	#define TEST_loggingManagedDocumentAutoSaving	FALSE
#endif

#if TEST_loggingManagedDocumentAutoSaving
	#define FXDdocLog	FXDLog
	#define FXDdocLog_DEFAULT	FXDLog_DEFAULT

#else
	#define FXDdocLog(__FORMAT__, ...)	{}
	#define FXDdocLog_DEFAULT

#endif


@interface FXDManagedDocument : UIManagedDocument

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
