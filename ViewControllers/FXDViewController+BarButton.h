//
//  FXDViewController+BarButton.h
//  KeyChamp
//
//  Created by petershine on 11/29/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//


#pragma mark - Category
@interface UIViewController (BarButton)

#pragma mark - Public
- (void)customizeBackBarbuttonWithDefaultImagesForTarget:(id)target shouldHideForRoot:(BOOL)shouldHideForRoot;

- (void)customizeLeftBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action;
- (void)customizeLeftBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action;

- (void)customizeRightBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action;
- (void)customizeRightBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action;

- (UIBarButtonItem*)barButtonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action;
- (UIView*)buttonGroupWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage withOffset:(CGPoint)offset orWithText:(NSString*)text forTarget:(id)target forAction:(SEL)action;

@end
