//
//  FXDFetchedResultsController.h
//
//
//  Created by petershine on 7/4/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDFetchedResultsController : NSFetchedResultsController {
    // Primitives
	
	// Instance variables
}

// Properties
@property (weak, nonatomic) id<NSFetchedResultsControllerDelegate> dynamicDelegate;


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSFetchedResultsController (Added)
- (FXDManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue;
- (FXDManagedObject*)resultObjForPredicate:(NSPredicate*)predicate;

@end
