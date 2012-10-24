//
//  FXDsuperCoreDataManager+CSVparser.h
//
//
//  Created by Peter SHINe on 6/3/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDKit.h"

#import "CHCSV.h"


#import "FXDsuperCoreDataManager.h"

@interface FXDsuperCoreDataManager (CSVparser) <CHCSVParserDelegate> {
	// Primitives

	// Instance variables
}

// Properties


#pragma mark - Public
- (void)parseFromCSVfileName:(NSString*)csvFileName;
- (void)insertParsedObjForEntityName:(NSString*)entityName usingKeys:(NSArray*)keys usingValues:(NSArray*)values;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - CHCSVParserDelegate


@end
