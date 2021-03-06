

#import "FXDManagedObject.h"


@implementation NSManagedObject (Essential)
- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter {
    NSDictionary *attributes = self.entity.attributesByName;
	
    for (NSString *attribute in attributes) {
		id value = keyedValues[attribute];
		
		//MARK: Check cases
		if (value == nil) {
			value = keyedValues[attribute.uppercaseString];
		}
		
		if (value == nil) {
			value = keyedValues[attribute.lowercaseString];
		}
		
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
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
		else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && dateFormatter) {
            value = [dateFormatter dateFromString:value];
        }
		
        [self setValue:value forKey:attribute];
    }
}

@end
