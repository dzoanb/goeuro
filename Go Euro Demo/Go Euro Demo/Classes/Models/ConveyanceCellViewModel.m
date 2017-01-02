//
//  ConveyanceCellViewModel.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import SDWebImage;

#import "ConveyanceCellViewModel.h"

#import "Conveyance+CoreDataClass.h"

@interface ConveyanceCellViewModel ()

@property (readwrite, strong, nonatomic, nonnull) NSURL *providerLogoURL;
@property (readwrite, strong, nonatomic, nonnull) NSString *formattedDate;
@property (readwrite, strong, nonatomic, nonnull) NSString *formattedPrice;
@property (readwrite, strong, nonatomic, nonnull) NSString *formattedStopsNumber;

@end

@implementation ConveyanceCellViewModel

- (void)setImageHandler:(ConveyanceCellImageHandler)imageHandler
{
    if (!_imageHandler) {
        _imageHandler = imageHandler;
        [self downloadImageWithURL:self.providerLogoURL];
    }
}

#pragma mark - Initialization
- (instancetype)initWithConveyance:(Conveyance *)conveyance
{
    self = [super init];
    if (self) {
        NSString *urlWithSize = [conveyance.providerLogoUrl stringByReplacingOccurrencesOfString:@"{size}" withString:@"63"];
        _providerLogoURL = [NSURL URLWithString:urlWithSize];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        numberFormatter.currencySymbol = @"€";
        [numberFormatter setLenient:YES];
        _formattedPrice = [numberFormatter stringFromNumber:conveyance.price];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        _formattedDate = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:conveyance.departureTime], [dateFormatter stringFromDate:conveyance.arrivalTime]];
        
        _formattedStopsNumber = [NSString stringWithFormat:@"Stops number: %ld", (long)conveyance.stopsNumber];
    }
    return self;
}

- (void)downloadImageWithURL:(NSURL *)url
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!!image && !!image.CGImage) {
            UIImage *scaledImage = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            self.imageHandler(self, scaledImage);
        } else {
            self.imageHandler(self, nil);
        }
    }];
}

@end
