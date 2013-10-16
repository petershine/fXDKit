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
- (NSString*)leftAlignedParagraph;

- (NSString *)stringByCompressingWhitespaceTo:(NSString *)seperator;

@end
