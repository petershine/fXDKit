//
//  FXDsuperHTTPControl.h
//
//
//  Created by petershine on 10/27/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDsuperHTTPControl : FXDObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties
	NSInteger _httpContentLength;
	NSInteger _receivedDataLength;
	
	NSURL *_httpURL;
	NSMutableURLRequest *_httpRequest;
	NSURLConnection *_httpConnection;
	
	NSMutableData *_receivedData;
	
	FXDsuperHTTPControl *_nextHttpControl;
}

// Properties
@property (nonatomic, assign) NSInteger httpContentLength;
@property (nonatomic, assign) NSInteger receivedDataLength;

@property (retain, nonatomic) NSURL *httpURL;
@property (retain, nonatomic) NSMutableURLRequest *httpRequest;
@property (retain, nonatomic) NSURLConnection *httpConnection;

@property (retain, nonatomic) NSMutableData *receivedData;

@property (retain, nonatomic) FXDsuperHTTPControl *nextHttpControl;


#pragma mark - Memory managment

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (void)prepareConnectionReachabilities;
+ (void)deallocateConnectionReachabilities;

+ (BOOL)isWiFiConnected;

+ (NSMutableSet*)httpControlSet;
+ (FXDsuperHTTPControl*)popAndRemoveAnyHttpControlFromSet;
+ (void)addHttpControl:(FXDsuperHTTPControl*)httpControl toHttpControlSet:(NSMutableSet*)httpControlSet;

- (void)observedReachabilityChanged:(id)notification;

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
