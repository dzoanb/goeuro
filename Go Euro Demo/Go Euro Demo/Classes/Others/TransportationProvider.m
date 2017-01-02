//
//  TransportationProvider.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "TransportationProvider.h"

#import "CoreDataStackController.h"
#import "ConveyancesAPIClient.h"

@interface TransportationProvider ()

@property (strong, nonatomic, nonnull) CoreDataStackController *stackController;
@property (strong, nonatomic, nonnull) NSObject <APIClient> *apiClient;

@end

@implementation TransportationProvider

#pragma mark - Initialization
- (instancetype)initWithCoreDataStackController:(CoreDataStackController *)controller
{
    return [self initWithCoreDataStackController:controller apiClient:[[ConveyancesAPIClient alloc] init]];
}

- (nonnull instancetype)initWithCoreDataStackController:(nonnull CoreDataStackController *)controller apiClient:(nonnull NSObject <APIClient> *)apiClient
{
    self = [super init];
    if (self) {
        _stackController = controller;
        _apiClient = apiClient;
    }
    return self;
}

#pragma mark - Public methods
- (void)reloadDataOfType:(ConveyanceType)type withCompletionCallback:(nullable ReloadCompletionBlock)completionBlock
{
    __typeof(self) weakSelf = self;
    void (^completionHelperBlock)(NSArray *, ConveyanceType, NSError *) = ^void(NSArray *conveyancesJSON, ConveyanceType type, NSError *error) {
        if (error) {
            if (completionBlock) {
                completionBlock(@[], error);
            }
            return;
        }
        NSMutableArray *existingConveyances = [[Conveyance conveyancesOfType:type inContext:weakSelf.stackController.managedObjectContext] mutableCopy];
        
        NSMutableArray *conveyances = [NSMutableArray arrayWithCapacity:[conveyancesJSON count]];
        for (NSDictionary *dict in conveyancesJSON) {
            Conveyance *conveyance = [Conveyance createOrUpdateConveyanceWithDictionary:dict type:type inContext:weakSelf.stackController.managedObjectContext];
            if (!conveyance) {
                NSAssert(conveyance, @"Couldn't create object from data.");
                continue;
            }
            [conveyances addObject:conveyance];
        }
        [existingConveyances removeObjectsInArray:conveyances];
        
        for (Conveyance *conveyance in existingConveyances) {
            [Conveyance deleteConveyance:conveyance inContext:weakSelf.stackController.managedObjectContext];
        }
        
        [weakSelf.stackController save];
        
        if (completionBlock) {
            completionBlock(conveyances, nil);
        }
    };
    switch (type) {
        case ConveyanceTypeFlight: {
            [self.apiClient fetchFlightsWithCompletionBlock:^(NSArray<NSDictionary *> * _Nonnull conveyancesJSON, NSError * _Nullable error) {
                completionHelperBlock(conveyancesJSON, ConveyanceTypeFlight, error);
            }];
            break;
        }
        case ConveyanceTypeTrain: {
            [self.apiClient fetchTrainsWithCompletionBlock:^(NSArray<NSDictionary *> * _Nonnull conveyancesJSON, NSError * _Nullable error) {
                completionHelperBlock(conveyancesJSON, ConveyanceTypeTrain, error);
            }];
            break;
        }
        case ConveyanceTypeBus: {
            [self.apiClient fetchBusesWithCompletionBlock:^(NSArray<NSDictionary *> * _Nonnull conveyancesJSON, NSError * _Nullable error) {
                completionHelperBlock(conveyancesJSON, ConveyanceTypeBus, error);
            }];
            break;
        }
    }
    
}

- (NSArray <Conveyance *> *)conveyancesOfType:(ConveyanceType)type
{
    return [Conveyance conveyancesOfType:type inContext:self.stackController.managedObjectContext];
}

@end
