

#import "FXDPopoverBackgroundView.h"


@implementation FXDPopoverBackgroundView

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	__weak FXDPopoverBackgroundView *weakInstance = [[self class] sharedInstance];

	weakInstance.shouldHideArrowView = NO;

	weakInstance.titleText = nil;
	weakInstance.viewTitle = nil;
}

#pragma mark - Initialization
+ (instancetype)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}

#pragma mark -
- (instancetype)initWithFrame:(CGRect)frame {	FXDLog_DEFAULT;
    self = [super initWithFrame:frame];

	//MARK: Cannot use awakeFromNib
    if (self) {
#if DEBUG
		self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:alphaValue05];
#endif
    }

    return self;
}


#pragma mark - Property overriding
- (CGFloat)arrowOffset {
	return _arrowOffset;
}

- (void)setArrowOffset:(CGFloat)arrowOffset {
	_arrowOffset = arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection {
	return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
	_arrowDirection = arrowDirection;
}


#pragma mark - Method overriding
+ (CGFloat)arrowHeight {	FXDLog_OVERRIDE;
	CGFloat arrowHeight = 22.0;

	__weak FXDPopoverBackgroundView *weakInstance = [[self class] sharedInstance];
	if (weakInstance.shouldHideArrowView) {
		arrowHeight = 0.0;
	}

	return arrowHeight;
}

+ (CGFloat)arrowBase {	FXDLog_OVERRIDE;
	CGFloat arrowBase = 22.0;

	__weak FXDPopoverBackgroundView *weakInstance = [[self class] sharedInstance];
	if (weakInstance.shouldHideArrowView) {
		arrowBase = 0.0;
	}

	return arrowBase;
}

+ (UIEdgeInsets)contentViewInsets {	FXDLog_OVERRIDE;
	CGFloat minimumInset = [self minimumInset];
	
	return UIEdgeInsetsMake(minimumInset, minimumInset, minimumInset, minimumInset);
}

- (void)layoutSubviews {	FXDLog_DEFAULT;
	[super layoutSubviews];

	CGFloat arrowHeight = [[self class] arrowHeight];
	CGFloat arrowBase = [[self class] arrowBase];

	UIEdgeInsets contentViewInsets = [[self class] contentViewInsets];


	if (self.viewBackground == nil) {
		self.viewBackground = [[UIView alloc] initWithFrame:
							   CGRectMake(0,
										  arrowHeight,
										  self.frame.size.width,
										  self.frame.size.height -arrowHeight)];

#if DEBUG
		self.viewBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alphaValue05];
#else
		self.viewBackground.backgroundColor = [UIColor clearColor];
#endif

		self.viewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

		[self addSubview:self.viewBackground];
	}


	if (self.imageviewArrow == nil) {
		self.imageviewArrow = [[UIImageView alloc] initWithFrame:
							   CGRectMake(0,
										  0,
										  arrowBase,
										  arrowHeight)];

#if DEBUG
		self.imageviewArrow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alphaValue05];
#else
		self.imageviewArrow.backgroundColor = [UIColor clearColor];
#endif

		//TODO: Modify based on arrowDirection
		CGFloat modifiedCenterX = (self.frame.size.width/2.0) +self.arrowOffset;
		self.imageviewArrow.center = CGPointMake(modifiedCenterX, self.imageviewArrow.center.y);

		[self addSubview:self.imageviewArrow];
	}


	__weak FXDPopoverBackgroundView *weakInstance = [[self class] sharedInstance];
	self.titleText = weakInstance.titleText;
	self.viewTitle = weakInstance.viewTitle;


	if (self.viewTitle == nil && self.titleText == nil) {
		self.viewTitle = [[UILabel alloc] initWithFrame:
						  CGRectMake(0,
									 0,
									 self.frame.size.width,
									 contentViewInsets.top)];

		self.viewTitle.backgroundColor = [UIColor clearColor];

		((UILabel*)self.viewTitle).textAlignment = NSTextAlignmentCenter;
		((UILabel*)self.viewTitle).font = [UIFont boldSystemFontOfSize:20];
		((UILabel*)self.viewTitle).textColor = [UIColor whiteColor];
		((UILabel*)self.viewTitle).shadowColor = [UIColor darkGrayColor];

		((UILabel*)self.viewTitle).text = self.titleText;
	}

	if (self.viewTitle) {
		CGFloat minimumInset = [[self class] minimumInset];
		
		CGRect modifiedFrame = self.viewTitle.frame;
		modifiedFrame.origin.x = minimumInset;

		modifiedFrame.origin.y = ((contentViewInsets.top -modifiedFrame.size.height)/2.0);
		modifiedFrame.origin.y += arrowHeight;
		modifiedFrame.origin.y -= (minimumInset/2.0);

		modifiedFrame.size.width = self.frame.size.width -(minimumInset*2.0);

		self.viewTitle.frame = modifiedFrame;

		[self addSubview:self.viewTitle];
		[self bringSubviewToFront:self.viewTitle];
	}
}

#pragma mark - IBActions

#pragma mark - Public
+ (CGFloat)minimumInset {	FXDLog_OVERRIDE;
	return 0.0;
}

#pragma mark - Observer

#pragma mark - Delegate

@end
