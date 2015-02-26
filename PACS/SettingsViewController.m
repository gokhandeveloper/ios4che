//
//  SettingsViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 25/02/2015.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "define.h"
#import "Global.h"
@implementation SettingsViewController



- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:ISLOGGED_IN]){
        SettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *wadoUrlKey = nil;
    NSString *webServiceDirectoryKey = nil;
    NSString *portNumberKey =nil;
    NSString *hyperText = nil;
    if (standardUserDefaults)
        wadoUrlKey = [standardUserDefaults objectForKey:@"wadoUrlStored"];
    webServiceDirectoryKey = [standardUserDefaults objectForKey:@"directoryStored"];
    portNumberKey= [standardUserDefaults objectForKey:@"portNumberStored"];
    hyperText = [standardUserDefaults objectForKey:@"hyptertextStored"];
    
    
    
}

- (IBAction)saveSettingsButton:(id)sender {
    
  
}
@end
