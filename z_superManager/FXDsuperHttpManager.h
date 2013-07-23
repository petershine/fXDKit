//
//  FXDsuperHttpManager.h
//
//
//  Created by petershine on 10/27/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "Reachability.h"


@interface FXDsuperHttpManager : FXDObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    // Primitives
	NSInteger _httpContentLength;
	NSInteger _receivedDataLength;
	NSURL *_httpURL;
	NSMutableURLRequest *_httpRequest;
	NSURLConnection *_httpConnection;

	NSMutableData *_receivedData;

	FXDsuperHttpManager *_nextHttpControl;
}

// Properties
@property (nonatomic) NSInteger httpContentLength;
@property (nonatomic) NSInteger receivedDataLength;

@property (strong, nonatomic) NSURL *httpURL;
@property (strong, nonatomic) NSMutableURLRequest *httpRequest;
@property (strong, nonatomic) NSURLConnection *httpConnection;

@property (strong, nonatomic) NSMutableData *receivedData;

@property (strong, nonatomic) FXDsuperHttpManager *nextHttpControl;


#pragma mark - Public
+ (void)prepareConnectionReachabilities;
+ (void)deallocateConnectionReachabilities;

+ (BOOL)isWiFiConnected;

+ (NSMutableSet*)httpControlSet;
+ (FXDsuperHttpManager*)popAndRemoveAnyHttpControlFromSet;
+ (void)addHttpControl:(FXDsuperHttpManager*)httpControl toHttpControlSet:(NSMutableSet*)httpControlSet;

- (void)observedReachabilityChanged:(NSNotification*)notification;

- (void)startHttpConnectionWithURLstring:(NSString*)urlString;
- (void)startHttpConnectionWithURLstring:(NSString*)urlString withPostBody:(id)postBody withHttpHeaders:(NSDictionary*)httpHeaders;


//MARK: - Delegate implementation
#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;


@end
