//
//  CoreDataStackController.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import CoreData;

@interface CoreDataStackController : NSObject

typedef void (^InitCallbackBlock)(void);

#pragma mark - Properties
@property (readonly, strong, nonatomic, nullable) NSManagedObjectContext *managedObjectContext;

#pragma mark - Initialization
- (nonnull instancetype)initWithCallback:(nullable InitCallbackBlock)callback NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

#pragma mark - Methods
- (void)save;

@end
