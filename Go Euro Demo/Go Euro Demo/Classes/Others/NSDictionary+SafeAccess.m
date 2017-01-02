//
//  NSDictionary+SafeAccess.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "NSDictionary+SafeAccess.h"

@implementation NSDictionary (SafeAccess)

- (NSNumber *)numberForKey:(NSString *)key
{
    if ([self[key] isKindOfClass:[NSNumber class]]) {
        return self[key];
    }
    return nil;
}

- (NSDecimalNumber *)priceForKey:(NSString *)key
{
    if ([self[key] isKindOfClass:[NSNumber class]]) {
        NSString *priceString = [NSString stringWithFormat:@"%.2lf", [self[key] doubleValue]];
        return [NSDecimalNumber decimalNumberWithString:priceString];
    } else if ([self[key] isKindOfClass:[NSString class]]) {
        return [NSDecimalNumber decimalNumberWithString:self[key]];
    }
    return nil;
}

- (NSDate *)dateForKey:(NSString *)key
{
    if ([self[key] isKindOfClass:[NSString class]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"H:mm"];
        return [dateFormatter dateFromString:self[key]];
    }
    return nil;
}

- (NSString *)stringForKey:(NSString *)key
{
    if ([self[key] isKindOfClass:[NSString class]]) {
        return self[key];
    }
    return nil;
}

@end
