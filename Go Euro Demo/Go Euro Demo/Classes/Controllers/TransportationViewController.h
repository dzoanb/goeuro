//
//  TransportationViewController.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import UIKit;
@import XLPagerTabStrip;

@class CoreDataStackController;

@interface TransportationViewController : XLButtonBarPagerTabStripViewController

@property (strong, nonatomic, nonnull) CoreDataStackController *stackController;

@end

