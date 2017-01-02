//
//  ConveyancesListDataSource.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import UIKit;

@class Conveyance;
@class ConveyanceTableViewCell;

@interface ConveyancesListDataSource : NSObject <UITableViewDataSource>

typedef NSArray <Conveyance *> * _Nonnull (^ConveyancesSourceBlock)();
typedef void (^ConveyanceCellConfigurationBlock)(ConveyanceTableViewCell * _Nonnull cell, Conveyance *_Nonnull conveyance);

#pragma mark - Initialization
- (nonnull instancetype)initWithSourceBlock:(nonnull ConveyancesSourceBlock)conveyancesSourceBlock
                     cellConfigurationBlock:(nonnull ConveyanceCellConfigurationBlock)configurationBlock NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end
