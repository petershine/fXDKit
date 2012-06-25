//
//  FXDManagedObject.m
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDManagedObject.h"


#pragma mark - Private interface
@interface FXDManagedObject (Private)
@end


#pragma mark - Public implementation
@implementation FXDManagedObject

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management


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


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSManagedObject (Added)
- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter {
    NSDictionary *attributes = [[self entity] attributesByName];
	
    for (NSString *attribute in attributes) {
		id value = keyedValues[attribute];
		
		//MARK: Check cases
		if (value == nil) {
			value = keyedValues[[attribute uppercaseString]];
		}
		if (value == nil) {
			value = keyedValues[[attribute lowercaseString]];
		}
		
        if (value == nil) {
            continue;	// EMPTY
        }
		
        NSAttributeType attributeType = [attributes[attribute] attributeType];
		
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [[value stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
		else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = @([value integerValue]);
        }
		else if ((attributeType == NSFloatAttributeType || attributeType == NSDoubleAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
            value = @([value doubleValue]);
        }
		else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
            value = [dateFormatter dateFromString:value];
        }
		
        [self setValue:value forKey:attribute];
    }
}


@end