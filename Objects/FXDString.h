//
//  FXDString.h
//
//
//  Created by petershine on 3/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDString : NSString
@end


#pragma mark - Category
@interface NSString (Added)
+ (NSString*)uniqueKeyFrom:(Float64)doubleValue;
+ (NSString*)uniqueFilenameWithWithPrefix:(NSString*)prefix forType:(CFStringRef)type;
+ (NSString*)filenameWithWithPrefix:(NSString*)prefix withUniqueKey:(NSString*)uniqueKey forType:(CFStringRef)type;

- (NSString*)leftAlignedParagraph;

- (NSString *)stringByCompressingWhitespaceTo:(NSString *)seperator;

@end
