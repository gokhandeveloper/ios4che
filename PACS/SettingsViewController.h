//
//  SettingsViewController.h
//  PACS
//
//  Created by Gokhan Dilek on 25/02/2015.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameInSettings;
@property (weak, nonatomic) IBOutlet UITextField *passwordInSettings;
@property (weak, nonatomic) IBOutlet UITextField *wadoUrlInSettings;
@property (weak, nonatomic) IBOutlet UITextField *directoryInSettings;
- (IBAction)saveSettingsButton:(id)sender;

@end