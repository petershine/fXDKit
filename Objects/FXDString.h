//
//  FXDString.h
//
//
//  Created by petershine on 3/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDString : NSString
// Properties

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface NSString (Added)
+ (NSString*)uniqueKeyFrom:(Float64)doubleVariable;
+ (NSString*)uniqueFilenameWithWithPrefix:(NSString*)prefix forType:(NSString*)type;

- (NSString*)leftAlignedParagraph;

- (NSString *)stringByCompressingWhitespaceTo:(NSString *)seperator;

- (NSString*)replacedSelf;
@end
