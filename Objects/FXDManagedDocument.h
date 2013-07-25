//
//  FXDManagedDocument.h
//
//
//  Created by petershine on 7/25/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#if TEST_loggingManagedDocument
	#ifndef FXDdocLog
		#define FXDdocLog	FXDLog
	#endif

	#ifndef FXDdocLog_DEFAULT
		#define FXDdocLog_DEFAULT	FXDLog_DEFAULT
	#endif

#else
	#define FXDdocLog
	#define FXDdocLog_DEFAULT

#endif


@interface FXDManagedDocument : UIManagedDocument

// Properties


#pragma mark - Initialization

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
