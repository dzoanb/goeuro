//
//  TransportationProviderTests.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CoreDataStackController+CleanUp.h"
#import "TransportationProvider.h"
#import "MockAPIClient.h"

@interface TransportationProviderTests : XCTestCase

@property (strong, nonatomic, nonnull) TransportationProvider *provider;
@property (strong, nonatomic, nonnull) CoreDataStackController *stackController;
@property (strong, nonatomic, nonnull) MockAPIClient *apiClient;

@end

@implementation TransportationProviderTests

- (void)setUp
{
    [super setUp];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for CoreData stack setup"];
    self.stackController = [[CoreDataStackController alloc] initWithCallback:^{
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Error while CoreData setup.");
    }];
    
    self.apiClient = [[MockAPIClient alloc] init];
    self.provider = [[TransportationProvider alloc] initWithCoreDataStackController:self.stackController apiClient:self.apiClient];
}

- (void)tearDown
{
    [super tearDown];
    [self.stackController cleanUp];
}


- (void)testFetchFromEmptyDatabase
{
    NSArray *conveyances = [self.provider conveyancesOfType:ConveyanceTypeFlight];
    
    XCTAssertEqual([conveyances count], 0);
}

- (void)testFetchFromBackend
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"wait for flights fetch"];
    
    [self.provider reloadDataOfType:ConveyanceTypeFlight withCompletionCallback:^(NSArray<Conveyance *> * _Nonnull conveyances, NSError * _Nullable error) {
        
        XCTAssertNil(error);
        XCTAssertEqual([conveyances count], 3);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Error while retriving data");
    }];
}

- (void)testFetchFromBackendAndRefresh
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for flights fetch."];
    
    [self.provider reloadDataOfType:ConveyanceTypeFlight withCompletionCallback:^(NSArray<Conveyance *> * _Nonnull conveyances, NSError * _Nullable error) {
        
        XCTAssertNil(error);
        XCTAssertEqual([conveyances count], 3);
        
        [self.provider reloadDataOfType:ConveyanceTypeFlight withCompletionCallback:^(NSArray<Conveyance *> * _Nonnull conveyances, NSError * _Nullable error) {
            
            XCTAssertNil(error);
            XCTAssertEqual([conveyances count], 3);
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Error while retriving data");
    }];
}

- (void)testFetchFromBackendTwoTypes
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for flights and buses fetch."];
    
    [self.provider reloadDataOfType:ConveyanceTypeFlight withCompletionCallback:^(NSArray<Conveyance *> * _Nonnull conveyances, NSError * _Nullable error) {
        
        XCTAssertNil(error);
        XCTAssertEqual([conveyances count], 3);
        
        [self.provider reloadDataOfType:ConveyanceTypeBus withCompletionCallback:^(NSArray<Conveyance *> * _Nonnull conveyances, NSError * _Nullable error) {
            
            XCTAssertNil(error);
            XCTAssertEqual([conveyances count], 6);
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Error while retriving data");
    }];
}

- (void)testFetchFromBackendAndAccessLocally
{
    XCTestExpectation *fetchExpectation = [self expectationWithDescription:@"!ait for flights fetch."];
    
    [self.provider reloadDataOfType:ConveyanceTypeFlight withCompletionCallback:^(NSArray<Conveyance *> * _Nonnull conveyances, NSError * _Nullable error) {
        
        XCTAssertNil(error);
        XCTAssertEqual([conveyances count], 3);
        
        NSArray *dbConveyances = [Conveyance conveyancesOfType:ConveyanceTypeFlight inContext:self.stackController.managedObjectContext];
        XCTAssertEqual([dbConveyances count], [conveyances count]);
        XCTAssertTrue([dbConveyances containsObject:[conveyances firstObject]]);
        
        [fetchExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Error while retriving data");
    }];
    
}

@end
