

#import "FXDCollectionViewLayout.h"


@implementation FXDCollectionViewLayout

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding
+ (Class)layoutAttributesClass {	FXDLog_DEFAULT;
	// override this method to provide a custom class to be used when instantiating instances of UICollectionViewLayoutAttributes
	Class attributesClass = [super layoutAttributesClass];
	FXDLogObject(attributesClass);

	return attributesClass;
}

+ (Class)invalidationContextClass NS_AVAILABLE_IOS(7_0) {
	// override this method to provide a custom class to be used for invalidation contexts

	Class contextClass = [super invalidationContextClass];
	FXDLogObject(contextClass);

	return contextClass;
}

#pragma mark -
- (void)prepareLayout {	FXDLog_DEFAULT;
	// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
	// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
	// Subclasses should always call super if they override.
	[super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {	FXDLog_DEFAULT;
	// return an array layout attributes instances for all the views in the given rect
	FXDLogRect(rect);

	NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
	FXDLogObject(attributes);

	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {	FXDLog_DEFAULT;
	FXDLogObject(indexPath);

	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];

	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {	FXDLog_DEFAULT;

	FXDLog(@"%@ %@", _Object(kind), _Object(indexPath));

	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];

	return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {	FXDLog_DEFAULT;

	FXDLog(@"%@ %@", _Object(decorationViewKind), _Object(indexPath));

	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];

	return attributes;
}

#pragma mark -
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {	FXDLog_DEFAULT;
	// return YES to cause the collection view to requery the layout for geometry information

	FXDLogRect(newBounds);

	BOOL shouldInvalidate = [super shouldInvalidateLayoutForBoundsChange:newBounds];
	FXDLogBOOL(shouldInvalidate);

	return shouldInvalidate;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds NS_AVAILABLE_IOS(7_0) {	FXDLog_DEFAULT;
	FXDLogRect(newBounds);

	UICollectionViewLayoutInvalidationContext *invalidationContext = [super invalidationContextForBoundsChange:newBounds];

	return invalidationContext;
}

#pragma mark -
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {	FXDLog_DEFAULT;
	// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior

	FXDLog(@"%@ %@", _Point(proposedContentOffset), _Point(velocity));

	CGPoint contentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
	FXDLogPoint(contentOffset);

	return contentOffset;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0) {
	// a layout can return the content offset to be applied during transition or update animations

	FXDLog(@"%@", _Point(proposedContentOffset));

	CGPoint contentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
	FXDLogPoint(contentOffset);

	return contentOffset;
}

#pragma mark -
- (CGSize)collectionViewContentSize {	FXDLog_DEFAULT;
	// Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.
	CGSize contentSize = [super collectionViewContentSize];
	FXDLogSize(contentSize);

	return contentSize;
}


#pragma mark - Public

#pragma mark - Observer

#pragma mark - Delegate

@end
