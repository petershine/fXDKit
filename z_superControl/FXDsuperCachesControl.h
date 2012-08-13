//
//  FXDsuperCachesControl.h
//  EasyFileSharing
//
//  Created by petershine on 8/13/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDKit.h"

#define notificationCachesControlDidEnumerateCachesMetadataQueryResults	@"notificationCachesControlDidEnumerateCachesMetadataQueryResults"


@interface FXDsuperCachesControl : NSObject <NSMetadataQueryDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
}

// Properties
@property (strong, nonatomic) NSMetadataQuery *ubiquitousCachesMetadataQuery;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCachesControl*)sharedInstance;

- (UIImage*)thumbImageForItemURL:(NSURL*)itemURL forDimension:(CGFloat)thumbnailDimension;

- (NSURL*)cachedURLforItemURL:(NSURL*)itemURL;
- (NSURL*)cachedFolderURLforFolderURL:(NSURL*)folderURL;

- (void)addNewThumbImage:(UIImage*)thumbImage toCachedURL:(NSURL*)cachedURL;

- (void)manageCachedURLarrayWithItemURLarray:(NSArray*)itemURLarray forItemActionType:(ITEM_ACTION_TYPE)itemActionType fromCurrentFolderURL:(NSURL*)currentFolderURL toDestinationFolderURL:(NSURL*)destinationFolderURL;
- (void)manageCachedURLwithItemURL:(NSURL*)itemURL forItemActionType:(ITEM_ACTION_TYPE)itemActionType fromCurrentFolderURL:(NSURL*)currentFolderURL toDestinationFolderURL:(NSURL*)destinationFolderURL;

- (void)enumerateCachesMetadataQueryResults;


//MARK: - Observer implementation
- (void)observedCachesMetadataQueryDidFinishGathering:(NSNotification*)notification;
- (void)observedCachesMetadataQueryDidUpdate:(NSNotification*)notification;

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface FXDsuperCachesControl (Added)
@end
