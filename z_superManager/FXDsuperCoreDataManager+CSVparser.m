//
//  FXDsuperCoreDataManager+CSVparser.m
//
//
//  Created by Peter SHINe on 6/3/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDsuperCoreDataManager+CSVparser.h"


@implementation FXDsuperCoreDataManager (CSVparser)

- (void)parseFromCSVfileName:(NSString*)csvFileName {	FXDLog_DEFAULT;
	NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:csvFileName ofType:@"csv"];
	
	NSError *error = nil;
	
	CHCSVParser *csvParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:csvFilePath encoding:NSUTF8StringEncoding error:&error];
	[csvParser setParserDelegate:self];
	
	[csvParser parse];
	
	if (error) {
		FXDLog_ERROR;
	}
}

- (void)insertParsedObjForEntityName:(NSString*)entityName usingKeys:(NSArray*)keys usingValues:(NSArray*)values {	FXDLog_DEFAULT;
	
	NSMutableDictionary *keysWithValues = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	for (NSInteger i = 0; i < [keys count]; i++) {
		NSString *key = [keys objectAtIndex:i];
		NSString *value = [values objectAtIndex:i];
		
		[keysWithValues setValue:value forKey:key];
	}
	
	//FXDLog(@"keysWithValues:\n%@", keysWithValues);
	
	NSManagedObject *insertedObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
	
	[insertedObj setValuesForKeysWithDictionary:keysWithValues dateFormatter:nil];
	
	FXDLog(@"insertedObj: %@", insertedObj);
}


//MARK: - Observer implementation


//MARK: - Delegate implementation
#pragma mark - CHCSVParserDelegate
- (void) parser:(CHCSVParser *)parser didStartDocument:(NSString *)csvFile {	FXDLog_DEFAULT;
	FXDLog(@"csvFile: %@", csvFile);
}

- (void) parser:(CHCSVParser *)parser didStartLine:(NSUInteger)lineNumber {	FXDLog_OVERRIDE;
	
}

- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field {	//FXDLog_DEFAULT;
	//FXDLog(@"field: %@", field);
	
	if (self.fieldValues == nil) {
		self.fieldValues = [[NSMutableArray alloc] initWithCapacity:0];
	}
	
	[self.fieldValues addObject:field];
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber {	//FXDLog_DEFAULT;
	//FXDLog(@"lineNumber: %u\n%@", lineNumber, self.fieldValues);
	
	if (lineNumber == 1) {	// Assume this is key line
		self.fieldKeys = nil;
		self.fieldKeys = [[NSMutableArray alloc] initWithArray:self.fieldValues];
	}
	else {
		if (self.fieldKeys) {
			[self insertParsedObjForEntityName:self.mainEntityName usingKeys:self.fieldKeys usingValues:self.fieldValues];
		}
	}
	
	self.fieldValues = nil;
}

- (void) parser:(CHCSVParser *)parser didEndDocument:(NSString *)csvFile {	FXDLog_DEFAULT;
	
	self.fieldKeys = nil;
	
	[self saveManagedObjectContext:nil forFinishedBlock:nil];
}

- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {	FXDLog_DEFAULT;
	if (error) {
		FXDLog_ERROR;
	}
	
	
	self.fieldKeys = nil;
	self.fieldValues = nil;
	
	[self saveManagedObjectContext:nil forFinishedBlock:nil];
}


@end
