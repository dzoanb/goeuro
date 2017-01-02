//
//  MockAPIClient.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "MockAPIClient.h"

@implementation MockAPIClient

- (void)fetchFlightsWithCompletionBlock:(FetchCompletionBlock)completionBlock
{
    completionBlock(@[
                      @{
                          @"id": @1,
                          @"provider_logo": @"http://google.com",
                          @"price_in_euros": @"31.20",
                          @"departure_time": @"10:31",
                          @"arrival_time": @"13:56",
                          @"number_of_stops": @0
                          },
                      @{
                          @"id": @2,
                          @"provider_logo": @"http://google.com",
                          @"price_in_euros": @"5.99",
                          @"departure_time": @"1:06",
                          @"arrival_time": @"15:12",
                          @"number_of_stops": @1
                          },
                      @{
                          @"id": @3,
                          @"provider_logo": @"http://google.com",
                          @"price_in_euros": @"1.75",
                          @"departure_time": @"11:25",
                          @"arrival_time": @"17:33",
                          @"number_of_stops": @2
                          }
                      ], nil);
}

- (void)fetchTrainsWithCompletionBlock:(FetchCompletionBlock)completionBlock
{
    completionBlock(@[], nil);
}

- (void)fetchBusesWithCompletionBlock:(FetchCompletionBlock)completionBlock
{
    completionBlock(@[
                      @{
                          @"id": @1,
                          @"provider_logo": @"http://google.com",
                          @"price_in_euros": @"31.32",
                          @"departure_time": @"10:31",
                          @"arrival_time": @"13:56",
                          @"number_of_stops": @0
                          },
                      @{
                          @"id": @2,
                          @"provider_logo": @"http://google.com",
                          @"price_in_euros": @"5.99",
                          @"departure_time": @"1:54",
                          @"arrival_time": @"15:12",
                          @"number_of_stops": @1
                          },
                      @{
                          @"id": @3,
                          @"provider_logo": @"http://google.com",
                          @"price_in_euros": @"1.75",
                          @"departure_time": @"11:15",
                          @"arrival_time": @"17:33",
                          @"number_of_stops": @2
                          }
                      ], nil);
}

@end
