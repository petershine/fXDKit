//
//  FXDMetadataQuery.h
//
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDMetadataQuery : NSMetadataQuery
@end


@interface NSMetadataQuery (Essential)
- (BOOL)isQueryResultsTransferring;
@end


@interface NSMetadataItem (Essential)
- (Float64)transferPercentage;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;
@end
