//
//  Conveyance+CoreDataClass.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, ConveyanceType) {
    ConveyanceTypeFlight,
    ConveyanceTypeTrain,
    ConveyanceTypeBus
};

NS_ASSUME_NONNULL_BEGIN

@interface Conveyance : NSManagedObject

#pragma mark - Properties
@property (readonly, assign, nonatomic) NSTimeInterval journeyDuration;

#pragma mark - Class methods
+ (nonnull instancetype)createOrUpdateConveyanceWithDictionary:(nonnull NSDictionary <NSString *, NSObject *> *)dictionary type:(ConveyanceType)type inContext:(nonnull NSManagedObjectContext *)context;
+ (nonnull NSArray <Conveyance *> *)conveyancesOfType:(ConveyanceType)type inContext:(nonnull NSManagedObjectContext *)context;
+ (void)deleteConveyance:(Conveyance *)conveyance inContext:(NSManagedObjectContext *)context;

#pragma mark - Class Properties
@property (class, readonly, nonatomic) NSSortDescriptor *arrivalTimeSortDescriptor;
@property (class, readonly, nonatomic) NSSortDescriptor *departureTimeSortDescriptor;
@property (class, readonly, nonatomic) NSSortDescriptor *journeyDurationSortDescriptor;

@end

NS_ASSUME_NONNULL_END

#import "Conveyance+CoreDataProperties.h"
