//
//  TransportationViewController.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "TransportationViewController.h"

#import "Conveyance+CoreDataClass.h"
#import "ConveyancesListViewController.h"
#import "CoreDataStackController.h"
#import "ConveyancesListDataSource.h"

@interface TransportationViewController ()

@property (strong, nonatomic, nonnull) NSArray <ConveyancesListViewController *> * conveyancesListsViewControllers;
@property (weak, nonatomic, nullable) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *dateLabel;

@end

@implementation TransportationViewController

#pragma mark - Getters / setters
- (void)setStackController:(CoreDataStackController *)stackController
{
    _stackController = stackController;
    [self configureTransportationLists];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.routeLabel.text = @"Berlin - Munich";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM d";
    self.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.isProgressiveIndicator = NO;
    self.buttonBarView.selectedBar.backgroundColor = [UIColor orangeColor];
    self.buttonBarView.backgroundColor = [UIColor colorWithRed:15/255.0 green:98/255.0 blue:163/255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (IBAction)sortButtonTouched:(UIBarButtonItem *)sender
{
    ConveyancesListViewController *selectedViewController = self.conveyancesListsViewControllers[self.currentIndex];
    [selectedViewController showSortActionSheet];
}

#pragma mark - Helpers
- (void)configureTransportationLists
{
    for (ConveyancesListViewController *vc in self.conveyancesListsViewControllers) {
        vc.stackController = self.stackController;
    }
}

- (ConveyancesListViewController *)conveyancesListVCWithType:(ConveyanceType)type
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConveyancesListViewController *conveyancesListVC = (ConveyancesListViewController *)[storyboard instantiateViewControllerWithIdentifier:[ConveyancesListViewController storyboardIdentifier]];
    conveyancesListVC.type = type;
    return conveyancesListVC;
}

#pragma mark - XLPagerTabStripViewControllerDataSource
- (NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    if (!self.conveyancesListsViewControllers) {
        self.conveyancesListsViewControllers = @[
                                                [self conveyancesListVCWithType:ConveyanceTypeFlight],
                                                [self conveyancesListVCWithType:ConveyanceTypeTrain],
                                                [self conveyancesListVCWithType:ConveyanceTypeBus]
                                                ];
    }
    return self.conveyancesListsViewControllers;
}

@end
