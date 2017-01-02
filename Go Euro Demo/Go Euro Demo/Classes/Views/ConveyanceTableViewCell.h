//
//  ConveyanceTableViewCell.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConveyanceCellViewModel;

@interface ConveyanceTableViewCell : UITableViewCell

#pragma mark - Methods
- (void)configureWithViewModel:(nonnull ConveyanceCellViewModel *)viewModel;

#pragma mark - Class properties
@property (class, readonly, nonatomic, nonnull) NSString *reusableIdentifier;

@end
