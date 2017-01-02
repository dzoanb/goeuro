//
//  ConveyanceTableViewCell.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import SDWebImage;

#import "ConveyanceTableViewCell.h"

#import "ConveyanceCellViewModel.h"

@interface ConveyanceTableViewCell ()

@property (weak, nonatomic, nullable) IBOutlet UIImageView *providerLogo;
@property (weak, nonatomic, nullable) IBOutlet UILabel *datesLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *stopsLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic, nonnull) ConveyanceCellViewModel *viewModel;

@end

@implementation ConveyanceTableViewCell

#pragma mark - Public
- (void)configureWithViewModel:(ConveyanceCellViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.providerLogo.image = [UIImage imageNamed:@"placeholder"];
    self.datesLabel.text = viewModel.formattedDate;
    self.stopsLabel.text = viewModel.formattedStopsNumber;
    self.priceLabel.text = viewModel.formattedPrice;
    
    __typeof(self) weakSelf = self;
    viewModel.imageHandler = ^(ConveyanceCellViewModel *_Nonnull viewModel, UIImage *_Nullable image) {
        if (weakSelf && weakSelf.viewModel == viewModel && image) {
            weakSelf.providerLogo.image = image;
        }
    };
}

#pragma mark - Class
+ (NSString *)reusableIdentifier
{
    return @"ConveyanceTableViewCellReusableIdentifier";
}

@end
