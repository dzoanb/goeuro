//
//  Conveyance+CoreDataProperties.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "Conveyance+CoreDataProperties.h"

@implementation Conveyance (CoreDataProperties)

+ (NSFetchRequest<Conveyance *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Conveyance"];
}

@dynamic arrivalTime;
@dynamic departureTime;
@dynamic id;
@dynamic price;
@dynamic providerLogoUrl;
@dynamic stopsNumber;
@dynamic type;

@end
