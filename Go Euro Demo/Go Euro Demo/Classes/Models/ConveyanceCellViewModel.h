//
//  ConveyanceCellViewModel.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import Foundation;
@import UIKit;

@class Conveyance;

@interface ConveyanceCellViewModel : NSObject

typedef void (^ConveyanceCellImageHandler)(ConveyanceCellViewModel *_Nonnull viewModel, UIImage *_Nullable image);

#pragma mark - Properties
@property (copy, nonatomic, nullable) ConveyanceCellImageHandler imageHandler;
@property (readonly, strong, nonatomic, nonnull) NSString *formattedDate;
@property (readonly, strong, nonatomic, nonnull) NSString *formattedPrice;
@property (readonly, strong, nonatomic, nonnull) NSString *formattedStopsNumber;

#pragma mark - Initialization
- (nonnull instancetype)initWithConveyance:(nonnull Conveyance *)conveyance;

@end
