//
//  APIClientProtocol.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#ifndef APIClientProtocol_h
#define APIClientProtocol_h

@protocol APIClient <NSObject>

typedef void (^FetchCompletionBlock)(NSArray <NSDictionary *> *_Nonnull conveyancesJSON, NSError *_Nullable error);

#pragma mark - Methods
/**
 Loads data for different conveyance types flights/trains/buses from backend in background.
 
 @param completionBlock FetchCompletionBlock called on main thread after receive data.
 */
- (void)fetchFlightsWithCompletionBlock:(nullable FetchCompletionBlock)completionBlock;
- (void)fetchTrainsWithCompletionBlock:(nullable FetchCompletionBlock)completionBlock;
- (void)fetchBusesWithCompletionBlock:(nullable FetchCompletionBlock)completionBlock;

@end

#endif /* APIClientProtocol_h */
