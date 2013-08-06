//
//  FXDTableViewCell.m
//
//
//  Created by petershine on 10/19/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDTableViewCell.h"


#pragma mark - Public implementation
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

	self.sectionPositionType = integerNotDefined;

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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {	//FXDLog_OVERRIDE;
    [super setSelected:selected animated:animated];

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {	//FXDLog_OVERRIDE;
	[super setHighlighted:highlighted animated:animated];
	
	if (self.imageView) {
		[self.imageView setHighlighted:highlighted];
	}
	
	if (self.textLabel) {
		[self.textLabel setHighlighted:highlighted];
	}
	
	if ([self.accessoryView isKindOfClass:[UIImageView class]]) {
		[(UIImageView*)self.accessoryView setHighlighted:highlighted];
	}
	
	if (self.backgroundImageview) {
		[self.backgroundImageview setHighlighted:highlighted];
	}
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {	FXDLog_DEFAULT;
	FXDLog(@"state: %d", state);
	[super willTransitionToState:state];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {	FXDLog_DEFAULT;
	FXDLog(@"state: %d", state);
	[super didTransitionToState:state];
}


#pragma mark - Public
- (void)customizeBackgroundWithImage:(UIImage*)image withHighlightedImage:(UIImage*)highlightedImage {	//FXDLog_DEFAULT;
	
	if (image) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		if (!self.backgroundImageview) {
			self.backgroundImageview = [[UIImageView alloc] initWithImage:image highlightedImage:highlightedImage];
			
			self.backgroundImageview.userInteractionEnabled = NO;
			
			CGRect modifiedFrame = self.backgroundImageview.frame;
			modifiedFrame.origin.x = (self.frame.size.width - self.backgroundImageview.frame.size.width)/2.0;
			[self.backgroundImageview setFrame:modifiedFrame];
			
			//FXDLog(@"modifiedFrame: %@", NSStringFromCGRect(modifiedFrame));
			
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


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark -  Category
@implementation UITableViewCell (Added)
- (void)customizeWithMainImage:(UIImage*)mainImage withHighlightedMainImage:(UIImage*)highlightedMainImage {
	
	self.imageView.image = mainImage;
	
	if (highlightedMainImage) {
		self.imageView.highlightedImage = highlightedMainImage;
	}
}

- (void)modifySizeOfCellSubview:(UIView*)cellSubview {	//FXDLog_OVERRIDE;
	
}

- (void)modifyOriginXofCellSubview:(UIView*)cellSubview {	//FXDLog_OVERRIDE;
	
}

- (void)modifyOriginYofCellSubview:(UIView*)cellSubview {	//FXDLog_OVERRIDE;
	CGRect modifiedFrame = cellSubview.frame;
	
	modifiedFrame.origin.y = (self.frame.size.height -modifiedFrame.size.height)/2.0;
	
	[cellSubview setFrame:modifiedFrame];
}

@end