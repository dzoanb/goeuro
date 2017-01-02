//
//  ConveyancesListDataSource.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "ConveyancesListDataSource.h"

#import "Conveyance+CoreDataClass.h"
#import "ConveyanceTableViewCell.h"

@interface ConveyancesListDataSource ()

@property (copy, nonatomic, nonnull) ConveyancesSourceBlock sourceBlock;
@property (copy, nonatomic, nonnull) ConveyanceCellConfigurationBlock cellConfigurationBlock;

@end

@implementation ConveyancesListDataSource

#pragma mark - Initialization
- (nonnull instancetype)initWithSourceBlock:(ConveyancesSourceBlock)conveyancesSourceBlock
                     cellConfigurationBlock:(ConveyanceCellConfigurationBlock)configurationBlock
{
    self = [super init];
    if (self) {
        _sourceBlock = conveyancesSourceBlock;
        _cellConfigurationBlock = configurationBlock;
    }
    return  self;
}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sourceBlock() count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConveyanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ConveyanceTableViewCell reusableIdentifier] forIndexPath:indexPath];
    Conveyance *conveyance = [self conveyanceOnIndexPath:indexPath];
    
    self.cellConfigurationBlock(cell, conveyance);
    return cell;
}

#pragma mark - Helpers
- (Conveyance *)conveyanceOnIndexPath:(NSIndexPath *)indexPath
{
    NSArray *conveyances = self.sourceBlock();
    return conveyances[indexPath.row];
}

@end
