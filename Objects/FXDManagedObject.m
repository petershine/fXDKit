//
//  FXDManagedObject.m
//
//
//  Created by Anonymous on 3/16/12.
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

// Controllers


#pragma mark - Memory management
- (void)dealloc {	
	// Instance variables
	
	// Properties
	
    // Controllers
	
	[super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
		
        // Controllers
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties

// Controllers


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
		id value = [keyedValues objectForKey:attribute];
		
		//MARK: 대문자와 소문자도 확인
		if (value == nil) {
			value = [keyedValues objectForKey:[attribute uppercaseString]];
		}
		if (value == nil) {
			value = [keyedValues objectForKey:[attribute lowercaseString]];
		}
		
        if (value == nil) {
            continue;	// EMPTY
        }
		
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
		
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [[value stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
		else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value integerValue]];
        }
		else if ((attributeType == NSFloatAttributeType || attributeType == NSDoubleAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        }
		else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
            value = [dateFormatter dateFromString:value];
        }
		
        [self setValue:value forKey:attribute];
    }
}


@end