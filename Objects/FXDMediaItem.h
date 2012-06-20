//
//  FXDMediaItem.h
//
//
//  Created by Peter SHINe on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "FXDKit.h"

#import <MediaPlayer/MediaPlayer.h>


@interface FXDMediaItem : MPMediaItem {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
}

// Properties


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface MPMediaItem (Added)
- (NSDictionary*)propertiesDictionary;

- (UIImage*)artworkImageWithSize:(CGSize)size;
- (NSString*)propertyTitle;
- (NSString*)propertyArtist;
- (NSString*)propertyAlbum;
- (NSString*)propertyGenre;

@end
