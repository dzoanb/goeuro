//
//  CoreDataStackController.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "CoreDataStackController.h"

@interface CoreDataStackController ()

@property (readwrite, strong, nonatomic, nullable) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, nullable) NSManagedObjectContext *privateContext;
@property (copy, nonatomic, nullable) InitCallbackBlock initCallback;
@property (strong, nonatomic, nullable) NSURL *storeURL;
@property (strong, nonatomic, nullable) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, nullable) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic, nullable) NSPersistentStore *persistentStore;

@end

@implementation CoreDataStackController

- (instancetype)initWithCallback:(InitCallbackBlock)callback
{
    self = [super init];
    if (self) {
        _initCallback = callback;
        [self initializeCoreDataStack];
    }
    return self;
}

- (void)save
{
    if (![self.privateContext hasChanges] && ![self.managedObjectContext hasChanges]) {
        return;
    }
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        
        NSAssert([self.managedObjectContext save:&error], @"Failed to save main context: %@\n%@", [error localizedDescription], [error userInfo]);
        
        [self.privateContext performBlockAndWait:^{
            NSError *privateError = nil;
            [self.privateContext save:&privateError];
            NSAssert(!privateError, @"Error saving private context: %@\n%@", [privateError localizedDescription], [privateError userInfo]);
        }];
    }];
}

#pragma mark - Helpers
- (void)initializeCoreDataStack
{
    if (self.managedObjectContext) {
        return;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Go_Euro_Demo" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(managedObjectModel, @"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
    self.managedObjectModel = managedObjectModel;
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSAssert(coordinator,  @"%@:%@ Failed to initialize presistent store coordinator", [self class], NSStringFromSelector(_cmd));
    self.coordinator = coordinator;
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [self.privateContext setPersistentStoreCoordinator:coordinator];
    [self.managedObjectContext setParentContext:self.privateContext];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *storeCoordinator = [self.privateContext persistentStoreCoordinator];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        self.storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
        
        NSError *error = nil;
        NSPersistentStore *persistentStore = [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:options error:&error];
        NSAssert(persistentStore, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
        self.persistentStore = persistentStore;
        
        if (self.initCallback) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.initCallback();
            });
        }
    });
}

#pragma mark - Private
- (void)cleanUp
{
    self.managedObjectContext = nil;
    self.privateContext = nil;
    
    self.persistentStore = nil;
    self.coordinator = nil;
    self.managedObjectModel = nil;
    
    NSURL *storeURL = self.storeURL;
    
    NSString *shm = [storeURL.path stringByAppendingString:@"-shm"];
    NSString *wal = [storeURL.path stringByAppendingString:@"-wal"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:shm]) {
        [[NSFileManager defaultManager] removeItemAtPath:shm error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:wal]) {
        [[NSFileManager defaultManager] removeItemAtPath:wal error:nil];
    }
}

@end
