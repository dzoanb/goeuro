//
//  Conveyance+CoreDataClass.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "Conveyance+CoreDataClass.h"
#import "NSDictionary+SafeAccess.h"

@interface Conveyance ()

@property (readwrite, assign, nonatomic) NSTimeInterval journeyDuration;

@end

@implementation Conveyance

@synthesize journeyDuration = _journeyDuration;

#pragma mark - Getters / setters
- (NSTimeInterval)journeyDuration
{
    if (!_journeyDuration) {
        _journeyDuration = [self.arrivalTime timeIntervalSinceDate:self.departureTime];
    }
    return _journeyDuration;
}

#pragma mark - Helpers
- (void)updateWithDictionary:(NSDictionary <NSString *, NSObject *> *)dictionary type:(ConveyanceType)type inContext:(NSManagedObjectContext *)context
{
    self.id =  [[dictionary numberForKey:@"id"] integerValue];
    self.providerLogoUrl = [dictionary stringForKey:@"provider_logo"];
    self.price = [dictionary priceForKey:@"price_in_euros"];
    self.departureTime = [dictionary dateForKey:@"departure_time"];
    self.arrivalTime = [dictionary dateForKey:@"arrival_time"];
    self.stopsNumber = [[dictionary numberForKey:@"number_of_stops"] integerValue];
    self.type = type;
}

#pragma mark - Class methods public
+ (nonnull instancetype)createOrUpdateConveyanceWithDictionary:(NSDictionary <NSString *, NSObject *> *)dictionary type:(ConveyanceType)type inContext:(NSManagedObjectContext *)context
{
    NSNumber *id = [dictionary numberForKey:@"id"];
    if (!id) {
        return nil;
    }
    
    Conveyance *conveyance = [self conveyanceWithId:[id integerValue] type:type inContext:context];
    if (!conveyance) {
        conveyance = [[self alloc] initWithContext:context];
    }
    
    [conveyance updateWithDictionary:dictionary type:type inContext:context];
    return conveyance;
}

+ (NSArray <Conveyance *> *)conveyancesOfType:(ConveyanceType)type inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [self fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"type == %d", type];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!!error) {
        NSAssert(!error, @"Error while fetching conveyances.");
    }
    return results ?: @[];
}

+ (void)deleteConveyance:(Conveyance *)conveyance inContext:(NSManagedObjectContext *)context
{
    [context deleteObject:conveyance];
}

#pragma mark - Class methods helpers
+ (nullable instancetype)conveyanceWithId:(NSInteger)id type:(ConveyanceType)type inContext:(nonnull NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %d AND type == %d", id, type];
    request.fetchLimit = 1;
    
    NSError *error = nil;
    Conveyance *result = [[context executeFetchRequest:request error:&error] firstObject];
    
    if (!!error) {
        NSAssert(!error, @"Couldn't fetch from db.");
    }
    return result;
}

#pragma mark - Class properties
+ (NSSortDescriptor *)arrivalTimeSortDescriptor
{
    return [NSSortDescriptor sortDescriptorWithKey:@"arrivalTime" ascending:YES];
}

+ (NSSortDescriptor *)departureTimeSortDescriptor
{
    return [NSSortDescriptor sortDescriptorWithKey:@"departureTime" ascending:YES];
}

+ (NSSortDescriptor *)journeyDurationSortDescriptor
{
    return [NSSortDescriptor sortDescriptorWithKey:@"journeyDuration" ascending:YES];
}

@end
