//
//  Conveyance+CoreDataProperties.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "Conveyance+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Conveyance (CoreDataProperties)

+ (NSFetchRequest<Conveyance *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *arrivalTime;
@property (nullable, nonatomic, copy) NSDate *departureTime;
@property (nonatomic) int64_t id;
@property (nullable, nonatomic, copy) NSDecimalNumber *price;
@property (nullable, nonatomic, copy) NSString *providerLogoUrl;
@property (nonatomic) int16_t stopsNumber;
@property (nonatomic) int16_t type;

@end

NS_ASSUME_NONNULL_END
