//
//  TransportationProvider.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import Foundation;

#import "Conveyance+CoreDataClass.h"

#import "APIClientProtocol.h"

@class CoreDataStackController;

@interface TransportationProvider : NSObject

typedef void (^ReloadCompletionBlock)(NSArray <Conveyance *> *_Nonnull conveyances, NSError *_Nullable error);

#pragma mark - Initialization
/**
 Initializes provider with CoreDataStackController.

 @param controller CoreDataStackController necessery to access data storage.
 @return TransportationProvider for accessing local and backend data. 
 */
- (nonnull instancetype)initWithCoreDataStackController:(nonnull CoreDataStackController *)controller;
- (nonnull instancetype)initWithCoreDataStackController:(nonnull CoreDataStackController *)controller apiClient:(nonnull NSObject <APIClient> *)apiClient NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

#pragma mark - Methods
/**
 Reloads data in background for passed type.

 @param type ConveyanceType to fetch data for.
 @param completionBlock ReloadCompletionBlock block called after fetching is done.
 */
- (void)reloadDataOfType:(ConveyanceType)type withCompletionCallback:(nullable ReloadCompletionBlock)completionBlock;

/**
 Loads data from database for passed type.

 @param type ConveyanceType to fetch data for.
 @return NSArray of Conveyance object of given type.
 */
- (nonnull NSArray <Conveyance *> *)conveyancesOfType:(ConveyanceType)type;

@end
