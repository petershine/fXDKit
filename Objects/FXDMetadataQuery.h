//
//  FXDMetadataQuery.h
///
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDMetadataQuery : NSMetadataQuery

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSMetadataQuery (Added)
- (BOOL)isQueryResultsTransferringWithLogString:(NSString*)logString;

@end


@interface NSMetadataItem (Added)
- (double)transferPercentage;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;


@end
