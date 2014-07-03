

#import "FXDTextView.h"


@implementation FXDTextView
@end


@implementation UITextView (Essential)
- (BOOL)verticalAlignWithChangedText:(NSString*)changedText {

	if (changedText == nil) {
		changedText = self.text;
	}


	CGRect boundingRect = [self boundingRectForChangedText:changedText
											forMaximumSize:self.bounds.size];

	NSInteger verticalOffset = (NSInteger)((self.bounds.size.height -self.font.pointSize -boundingRect.size.height)/2.0);

	if (verticalOffset < 0.0) {
		//FXDLog(@"%@, %@ lines: %f %@", _Variable(verticalOffset), _Variable(self.font.pointSize), (boundingRect.size.height/self.font.pointSize), _Object(self.text));
		return NO;
	}


	UIEdgeInsets modifiedInset = self.contentInset;
	modifiedInset.top = verticalOffset;

	CGPoint modifiedOffset = self.contentOffset;
	modifiedOffset.y = 0.0 -verticalOffset;

	if (UIEdgeInsetsEqualToEdgeInsets(modifiedInset, self.contentInset)
		&& CGPointEqualToPoint(modifiedOffset, self.contentOffset)) {
		return YES;
	}


	//FXDLog(@"%@ %@ %@ %@", _Variable(verticalOffset), _Struct(modifiedInset), _Point(modifiedOffset), _Object(self.text));

	self.contentInset = modifiedInset;
	[self setContentOffset:modifiedOffset animated:NO];

	return YES;
}

- (CGRect)boundingRectForChangedText:(NSString*)changedText forMaximumSize:(CGSize)maximumSize {
	CGRect boundingRect = [changedText
						   boundingRectWithSize:CGSizeMake(maximumSize.width, INFINITY)
						   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
						   attributes:@{NSFontAttributeName: self.font}
						   context:nil];

	return boundingRect;
}

@end