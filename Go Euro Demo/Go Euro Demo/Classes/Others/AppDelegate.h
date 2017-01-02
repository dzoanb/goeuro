//
//  AppDelegate.h
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

@import UIKit;
@import CoreData;

@class CoreDataStackController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#pragma mark - Properties
@property (strong, nonatomic, nonnull) UIWindow *window;
@property (readonly, strong, nonatomic, nonnull) CoreDataStackController *stackController;

@end

