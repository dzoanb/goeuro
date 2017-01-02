//
//  NSDictionary+SafeAccess.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeAccess)

- (nullable NSNumber *)numberForKey:(nonnull NSString *)key;
- (nullable NSDecimalNumber *)priceForKey:(nonnull NSString *)key;
- (nullable NSDate *)dateForKey:(nonnull NSString *)key;
- (nullable NSString *)stringForKey:(nonnull NSString *)key;

@end
