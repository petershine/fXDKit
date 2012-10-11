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
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties
	_sectionPositionType = integerNotDefined;
		
	// IBOutlets
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


#pragma mark - Accessor overriding


#pragma mark - Overriding


#pragma mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {	//FXDLog_DEFAULT;
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {	//FXDLog_DEFAULT;
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


#pragma mark - Public
- (void)customizeBackgroundWithImage:(UIImage*)image withHighlightedImage:(UIImage*)highlightedImage {	//FXDLog_DEFAULT;
	
	if (image) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		if (self.backgroundImageview == nil) {
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

#pragma mark -
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