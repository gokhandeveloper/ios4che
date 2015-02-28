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
    
    
[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
    
      [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)saveSettingsButton:(id)sender {
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"wadoUrlStored"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"directoryStored"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"portNumberStored"];
   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hyptertextStored"];
    
    [standardUserDefaults setObject:@"" forKey:@"wadoUrlStored"];
    [standardUserDefaults setObject:@"" forKey:@"directoryStored"];
    [standardUserDefaults setObject:@"" forKey:@"portNumberStored"];
   [standardUserDefaults setObject:@"" forKey:@"hyptertextStored"];
    NSString *usernameFromSetting, *passwordFromSetting, *wadoUrlFromSetting, *wadoDirectoryFromSetting, *portNumber, *http, *seperator, *loginWebService;
    
    usernameFromSetting = self.usernameInSettings.text;
    passwordFromSetting = self.passwordInSettings.text;
    wadoUrlFromSetting = self.wadoUrlInSettings.text;
    wadoDirectoryFromSetting = self.directoryInSettings.text;
    
    
    [standardUserDefaults setObject:wadoUrlFromSetting forKey:@"wadoUrlStored"];
    [standardUserDefaults setObject:wadoDirectoryFromSetting forKey:@"directoryStored"];
    if ([self.securitySwitchInSettings isOn]) {
        http = @"https://";
        portNumber = @":8443";
        [standardUserDefaults setObject:http forKey:@"hyptertextStored"];
        [standardUserDefaults setObject:portNumber forKey:@"portNumberStored"];
        
        
    }
    else {
        http = @"http://";
        portNumber = @":8080";
        [standardUserDefaults setObject:http forKey:@"hyptertextStored"];
        [standardUserDefaults setObject:portNumber forKey:@"portNumberStored"];

    
    }
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username": self.usernameInSettings.text,
                             @"password": self.passwordInSettings.text};
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    seperator = @"/";
      loginWebService =@"/login.jsp";
    NSArray *loginUrlParts = [[NSArray alloc] initWithObjects: http, wadoUrlFromSetting, portNumber, seperator, wadoDirectoryFromSetting, loginWebService ,nil];
    NSString *loginUrl = [loginUrlParts componentsJoinedByString:@""];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    [manager GET:loginUrl  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *strResponse = [[[operation responseString] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"01"] invertedSet]] componentsJoinedByString:@""];
    
    
    if ([strResponse isEqualToString:@"1"]){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISLOGGED_IN];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
        
        
        
    }else{
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:nil
                                                         message:@"Invalid Username or Password"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISLOGGED_IN];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:nil
                                                     message:@"Something went wrong. Please try again."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Error: %@", error);
}];
}
@end
