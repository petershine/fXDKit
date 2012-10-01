//
//  FXDCollectionViewLayout.m
//
//
//  Created by petershine on 10/1/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

#import "FXDCollectionViewLayout.h"


#pragma mark - Private interface
@interface FXDCollectionViewLayout (Private)
@end


#pragma mark - Public implementation
@implementation FXDCollectionViewLayout

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables

	// Properties
}


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
+ (Class)layoutAttributesClass {	FXDLog_DEFAULT;
	// override this method to provide a custom class to be used when instantiating instances of UICollectionViewLayoutAttributes
	Class attributesClass = [super layoutAttributesClass];
	FXDLog(@"attributesClass: %@", attributesClass);

	return attributesClass;
}

- (void)prepareLayout {	FXDLog_DEFAULT;
	// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
	// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
	// Subclasses should always call super if they override.
	[super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {	FXDLog_DEFAULT;
	// return an array layout attributes instances for all the views in the given rect
	FXDLog(@"rect: %@", NSStringFromCGRect(rect));

	NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
	FXDLog(@"attributes:\n%@", attributes);

	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {	FXDLog_DEFAULT;
	FXDLog(@"indexPath: %@", indexPath);

	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];

	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {	FXDLog_DEFAULT;

	FXDLog(@"kind: %@ indexPath: %@", kind, indexPath);

	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];

	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {	FXDLog_DEFAULT;

	FXDLog(@"decorationViewKind: %@ indexPath: %@", decorationViewKind, indexPath);

	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];

	return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {	FXDLog_DEFAULT;
	// return YES to cause the collection view to requery the layout for geometry information

	FXDLog(@"newBounds: %@", NSStringFromCGRect(newBounds));

	BOOL shouldInvalidate = [super shouldInvalidateLayoutForBoundsChange:newBounds];
	FXDLog(@"shouldInvalidate: %d", shouldInvalidate);

	return shouldInvalidate;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {	FXDLog_DEFAULT;
	// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior

	FXDLog(@"proposedContentOffset: %@ velocity: %@", NSStringFromCGPoint(proposedContentOffset), NSStringFromCGPoint(velocity));

	CGPoint contentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
	FXDLog(@"contentOffset: %@", NSStringFromCGPoint(contentOffset));

	return contentOffset;
}

- (CGSize)collectionViewContentSize {	FXDLog_DEFAULT;
	// Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.
	CGSize contentSize = [super collectionViewContentSize];
	FXDLog(@"contentSize: %@", NSStringFromCGSize(contentSize));

	return contentSize;
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
