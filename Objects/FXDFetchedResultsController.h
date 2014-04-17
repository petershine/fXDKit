//
//  FXDFetchedResultsController.h
//
//
//  Created by petershine on 7/4/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDFetchedResultsController : NSFetchedResultsController
@property (weak, nonatomic) id<NSFetchedResultsControllerDelegate> additionalDelegate;

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface NSFetchedResultsController (Added)
- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue;
- (NSManagedObject*)resultObjForPredicate:(NSPredicate*)predicate;
@end
