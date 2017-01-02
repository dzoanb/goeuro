//
//  ConveyancesListViewController.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import UIKit;
@import XLPagerTabStrip;

#import "Conveyance+CoreDataClass.h"

@class CoreDataStackController;

@interface ConveyancesListViewController : UIViewController <XLPagerTabStripChildItem>

typedef void (^ConveyancesListReloadCompletionBlock)(NSArray <Conveyance *> *_Nonnull conveyances);

#pragma mark - Properties
@property (assign, nonatomic) ConveyanceType type;
@property (strong, nonatomic, nonnull) CoreDataStackController *stackController;

#pragma mark - Methods
- (void)showSortActionSheet;

#pragma mark - Class properties
@property (class, readonly, nonatomic, nonnull) NSString *storyboardIdentifier;

@end
