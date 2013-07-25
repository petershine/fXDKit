//
//  FXDsuperCoreDataManager+CSVparser.h
//
//
//  Created by petershine on 5/10/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//
#if USE_csvParser

#import "FXDsuperCoreDataManager.h"

#import "CHCSV.h"


@interface FXDsuperCoreDataManager (CSVparser) <CHCSVParserDelegate>

// Properties
@property (strong, nonatomic) NSMutableArray *fieldValues;
@property (strong, nonatomic) NSMutableArray *fieldKeys;

#pragma mark - Public
- (void)parseFromCSVfileName:(NSString*)csvFileName;
- (void)insertParsedObjForEntityName:(NSString*)entityName usingKeys:(NSArray*)keys usingValues:(NSArray*)values;

#pragma mark - CHCSVParserDelegate

@end

#endif