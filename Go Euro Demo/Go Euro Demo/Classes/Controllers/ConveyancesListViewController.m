//
//  ConveyancesListViewController.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "ConveyancesListViewController.h"

#import "Conveyance+CoreDataClass.h"
#import "ConveyanceCellViewModel.h"
#import "ConveyancesListDataSource.h"
#import "ConveyanceTableViewCell.h"
#import "TransportationProvider.h"

@interface ConveyancesListViewController () <UITableViewDelegate>

#pragma mark Outlets
@property (weak, nonatomic, nullable) IBOutlet UITableView *conveyancesTableView;
@property (strong, nonatomic, nonnull) UIRefreshControl *refreshControl;

#pragma mark Models
@property (strong, nonatomic, nullable) ConveyancesListDataSource *dataSource;
@property (strong, nonatomic, nonnull) NSArray <Conveyance *> *conveyances;
@property (strong, nonatomic, nonnull) TransportationProvider *provider;
@property (strong, nonatomic, nonnull) NSSortDescriptor *sortDescriptor;
@property (strong, nonatomic, nonnull) UIAlertController *sortController;

@property (assign, nonatomic) CATransform3D translateTransform;

@end

@implementation ConveyancesListViewController

#pragma mark - Getters / setters
- (NSArray<Conveyance *> *)conveyances
{
    if (!_conveyances) {
        _conveyances = @[];
    }
    return _conveyances;
}

- (void)setStackController:(CoreDataStackController *)stackController
{
    if (!_stackController) {
        _stackController = stackController;
        self.provider = [[TransportationProvider alloc] initWithCoreDataStackController:stackController];
        [self refreshData];
    }
}

- (UIAlertController *)sortController
{
    if (!_sortController) {
        UIAlertController *alertContoller = [UIAlertController alertControllerWithTitle:@"Sort by" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *sortByDepartureTime = [UIAlertAction actionWithTitle:@"Departure Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.sortDescriptor = [Conveyance departureTimeSortDescriptor];
            [self reloadData];
        }];
        [alertContoller addAction:sortByDepartureTime];
        
        UIAlertAction *sortByArrivalTime = [UIAlertAction actionWithTitle:@"Arrival Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.sortDescriptor = [Conveyance arrivalTimeSortDescriptor];
            [self reloadData];
        }];
        [alertContoller addAction:sortByArrivalTime];
        
        UIAlertAction *sortByJourneyTime = [UIAlertAction actionWithTitle:@"Journey Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.sortDescriptor = [Conveyance journeyDurationSortDescriptor];
            [self reloadData];
            
        }];
        [alertContoller addAction:sortByJourneyTime];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertContoller addAction:cancelAction];
        
        _sortController = alertContoller;
    }
    return _sortController;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    [self.conveyancesTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];

    self.translateTransform = CATransform3DTranslate(CATransform3DIdentity, -CGRectGetWidth(self.view.bounds) / 2, 0, -5);
    
    self.conveyances = @[];
    self.sortDescriptor = [Conveyance departureTimeSortDescriptor];
    
    __typeof(self) weakSelf = self;
    ConveyancesListDataSource *dataSource = [[ConveyancesListDataSource alloc] initWithSourceBlock:^NSArray<Conveyance *> * _Nonnull{
        return weakSelf.conveyances;
    } cellConfigurationBlock:^(ConveyanceTableViewCell * _Nonnull cell, Conveyance * _Nonnull conveyance) {
        ConveyanceCellViewModel *cellViewModel = [[ConveyanceCellViewModel alloc] initWithConveyance:conveyance];
        [cell configureWithViewModel:cellViewModel];
    }];
    self.dataSource = dataSource;
    self.conveyancesTableView.dataSource = dataSource;
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark - Public methods
- (void)showSortActionSheet
{
    [self presentViewController:self.sortController animated:YES completion:nil];
}

#pragma mark - Helpers
- (void)reloadData
{
    if ([self.conveyances count] == 0) {
        self.conveyances = [self.provider conveyancesOfType:self.type];
    }
    
    if (self.sortDescriptor) {
        self.conveyances = [self.conveyances sortedArrayUsingDescriptors:@[self.sortDescriptor]];
    }
    
    [self.conveyancesTableView reloadData];
}

- (void)refreshData
{
    __typeof(self) weakSelf = self;
    [self.provider reloadDataOfType:self.type withCompletionCallback:^(NSArray<Conveyance *> * _Nonnull conveyances, NSError * _Nullable error) {
        [weakSelf.refreshControl endRefreshing];
        
        if (error) {
            UIAlertController *refreshAlertController = [UIAlertController alertControllerWithTitle:@"Failed to retrive data" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [refreshAlertController addAction:[UIAlertAction actionWithTitle:@"Got it!" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:refreshAlertController animated:YES completion:nil];
        }
        
        weakSelf.conveyances = conveyances;
        [weakSelf reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = self.translateTransform;
    cell.alpha = 0;
    
    [UIView beginAnimations:@"transform" context:NULL];
    [UIView setAnimationDuration:0.3];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    [UIView commitAnimations];
}

#pragma mark - XLPagerTabStripViewControllerDelegate
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    switch (self.type) {
        case ConveyanceTypeFlight:
            return @"Flights";
        case ConveyanceTypeBus:
            return @"Buses";
        case ConveyanceTypeTrain:
            return @"Trains";
    }
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor whiteColor];
}

#pragma mark - Class
+ (NSString *)storyboardIdentifier
{
    return @"ConveyancesListViewControllerIdentifier";
}

@end
