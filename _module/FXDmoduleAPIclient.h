//
//  FXDmoduleAPIclient.h
//
//
//  Created by petershine on 10/8/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import <AFNetworking.h>
#import <UIKit+AFNetworking.h>


@interface FXDmoduleAPIclient : FXDsuperModule {
	NSString *_mainRootURLformat;
	NSString *_mainAPIkey;
	NSString *_mainJSONrootKey;
}

@property (strong, nonatomic) NSString *mainRootURLformat;
@property (strong, nonatomic) NSString *mainAPIkey;
@property (strong, nonatomic) NSString *mainJSONrootKey;


#pragma mark - Public
- (void)collectingRequestWithQueryText:(NSString*)queryText withDidCollectBlock:(void(^)(NSMutableArray* collectedItemArray))didCollectBlock;
- (NSURLRequest*)requestWithQueryText:(NSString*)queryText;
- (NSMutableArray*)collectedItemArrayFromJSONobj:(id)jsonObj;
- (id)simplerItemFromItem:(id)item;

@end