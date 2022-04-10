

#import "FXDTableViewCell.h"


@implementation FXDTableViewCell

#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	self.positionCase = integerNotDefined;

	if (self.imageView) {
		[self modifySizeOfCellSubview:self.imageView];
		[self modifyOriginXofCellSubview:self.imageView];
		[self modifyOriginYofCellSubview:self.imageView];
	}
	
	if (self.textLabel) {
		[self modifySizeOfCellSubview:self.textLabel];
		[self modifyOriginXofCellSubview:self.textLabel];
		[self modifyOriginYofCellSubview:self.textLabel];
	}
	
	if (self.accessoryView) {
		[self modifySizeOfCellSubview:self.accessoryView];
		[self modifyOriginXofCellSubview:self.accessoryView];
		[self modifyOriginYofCellSubview:self.accessoryView];
	}
}

#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	
	if (self.imageView) {
		(self.imageView).highlighted = highlighted;
	}
	
	if (self.textLabel) {
		(self.textLabel).highlighted = highlighted;
	}
	
	if ([self.accessoryView isKindOfClass:[UIImageView class]]) {
		((UIImageView*)self.accessoryView).highlighted = highlighted;
	}
	
	if (self.backgroundImageview) {
		(self.backgroundImageview).highlighted = highlighted;
	}
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
	[super willTransitionToState:state];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
	[super didTransitionToState:state];
}


#pragma mark - Public
- (void)customizeBackgroundWithImage:(UIImage*)image withHighlightedImage:(UIImage*)highlightedImage {
	
	if (image) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		if (self.backgroundImageview == nil) {
			self.backgroundImageview = [[UIImageView alloc] initWithImage:image highlightedImage:highlightedImage];
			
			self.backgroundImageview.userInteractionEnabled = NO;
			
			CGRect modifiedFrame = self.backgroundImageview.frame;
			modifiedFrame.origin.x = (self.frame.size.width - self.backgroundImageview.frame.size.width)/2.0;
			self.backgroundImageview.frame = modifiedFrame;

			[self addSubview:self.backgroundImageview];
			[self sendSubviewToBack:self.backgroundImageview];
		}
		
		self.backgroundImageview.image = image;
		self.backgroundImageview.highlightedImage = highlightedImage;
	}
	else {
		if (self.backgroundImageview) {
			
			[self.backgroundImageview removeFromSuperview];
			self.backgroundImageview = nil;
			
			self.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
	}
}

#pragma mark - Observer

#pragma mark - Delegate

@end


@implementation UITableViewCell (Essential)
- (void)customizeWithMainImage:(UIImage*)mainImage withHighlightedMainImage:(UIImage*)highlightedMainImage {
	
	self.imageView.image = mainImage;
	
	if (highlightedMainImage) {
		self.imageView.highlightedImage = highlightedMainImage;
	}
}

- (void)modifySizeOfCellSubview:(UIView*)cellSubview {
}

- (void)modifyOriginXofCellSubview:(UIView*)cellSubview {
}

- (void)modifyOriginYofCellSubview:(UIView*)cellSubview {
	CGRect modifiedFrame = cellSubview.frame;
	modifiedFrame.origin.y = (self.frame.size.height -modifiedFrame.size.height)/2.0;
	cellSubview.frame = modifiedFrame;
}

@end
