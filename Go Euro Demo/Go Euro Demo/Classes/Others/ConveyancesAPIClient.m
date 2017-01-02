//
//  ConveyancesAPIClient.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "ConveyancesAPIClient.h"

@interface ConveyancesAPIClient ()

@property (strong, nonatomic, nonnull) NSURLSession *urlSession;
@property (strong, nonatomic, nonnull) NSURLRequest *flightsRequest;
@property (strong, nonatomic, nonnull) NSURLRequest *trainsRequest;
@property (strong, nonatomic, nonnull) NSURLRequest *busesRequest;

@end

@implementation ConveyancesAPIClient

#pragma mark - Getters / setters
- (NSURLSession *)urlSession
{
    if (!_urlSession) {
        _urlSession = [NSURLSession sharedSession];
    }
    return _urlSession;
}

- (NSURLRequest *)flightsRequest
{
    NSURL *URL = [NSURL URLWithString:@"https://api.myjson.com/bins/w60i"];
    return [NSURLRequest requestWithURL:URL];
}

- (NSURLRequest *)trainsRequest
{
    NSURL *URL = [NSURL URLWithString:@"https://api.myjson.com/bins/3zmcy"];
    return [NSURLRequest requestWithURL:URL];
}

- (NSURLRequest *)busesRequest
{
    NSURL *URL = [NSURL URLWithString:@"https://api.myjson.com/bins/37yzm"];
    return [NSURLRequest requestWithURL:URL];
}

#pragma mark - Public methods
- (void)fetchFlightsWithCompletionBlock:(FetchCompletionBlock)completionBlock
{
    [self fetchDataForRequest:self.flightsRequest withCompletionBlock:completionBlock];
}

- (void)fetchTrainsWithCompletionBlock:(FetchCompletionBlock)completionBlock
{
    [self fetchDataForRequest:self.trainsRequest withCompletionBlock:completionBlock];
}

- (void)fetchBusesWithCompletionBlock:(FetchCompletionBlock)completionBlock
{
    [self fetchDataForRequest:self.busesRequest withCompletionBlock:completionBlock];
}

#pragma mark - Helpers
- (void)fetchDataForRequest:(NSURLRequest *)request withCompletionBlock:(void (^)(NSArray *json, NSError *error))completionBlock
{
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSArray *json = nil;
        
        if (!error && data) {
            json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(json ?: @[], error);
        });
    }];
    [task resume];
}

@end
