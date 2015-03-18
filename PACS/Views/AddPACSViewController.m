//
//  AddPACSViewController.m
//  com.ios4che
//
//  Created by gokhan on 17/03/2015.
//  Copyright (c) 2015 Gokhan DIlek. All rights reserved.
//

#import "AddPACSViewController.h"
#import "PacsServerManager.h"
#import "PacsServer.h"
#import "SettingsViewController.h"
#import <KeychainItemWrapper.h>
@interface AddPACSViewController ()

@end

@implementation AddPACSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveForAddPacs:(id)sender {
    NSLog(@"Add button is working!");
    NSString *pacsNameFromAddPacsView, *usernameFromAddPacsView, *passwordFromAddPacsView, *wadoUrlFromAddPacsView, *portNumber, *http, *seperator, *loginWebService;
    
    pacsNameFromAddPacsView = self.pacsName.text;
    usernameFromAddPacsView = self.username.text;
    passwordFromAddPacsView = self.password.text;
    wadoUrlFromAddPacsView =self.wadoUrl.text;
    loginWebService = self.apiDirectory.text;
    
    
    addNewPacs = @[pacsNameFromAddPacsView, usernameFromAddPacsView, passwordFromAddPacsView, wadoUrlFromAddPacsView, loginWebService];
    
    NSData *newPacsData = [NSJSONSerialization dataWithJSONObject:addNewPacs options:0 error:NULL];
    NSString *newPacsDataString = [[NSString alloc] initWithData:newPacsData encoding:NSUTF8StringEncoding];
    KeychainItemWrapper *keychain =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"MyPacsData" accessGroup:nil];
    [keychain setObject:newPacsDataString forKey:(__bridge id)kSecValueData];
    [keychain setObject:pacsNameFromAddPacsView forKey:(__bridge id)kSecAttrService];
    
    NSString *pacsDataArray = [keychain objectForKey:(__bridge id)kSecValueData];
    NSString *pacsNameTobePassedToPickerView = [keychain objectForKey:(__bridge id)kSecAttrService];
    NSLog(@"Pacsdata name is:%@ which contains the following array %@",pacsNameTobePassedToPickerView ,pacsDataArray);
    
   [PacsServerManager pacsManager].pacsDataInStringArray = [NSString stringWithFormat:@"%@", pacsDataArray];
    
    SettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
