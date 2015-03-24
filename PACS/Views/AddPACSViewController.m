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
  //   [PacsServerManager pacsManager ].pacsServers= [[NSMutableArray alloc] init];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain  target:self action:@selector(saveForAddPacs:)];
    self.navigationItem.rightBarButtonItem = saveButton;
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

- (void)saveForAddPacs:(id)sender {
   
    NSString *pacsNameFromAddPacsView, *usernameFromAddPacsView, *passwordFromAddPacsView, *wadoUrlFromAddPacsView, *portNumber, *http, *seperator, *loginWebService;
    
    pacsNameFromAddPacsView = self.pacsName.text;
    usernameFromAddPacsView = self.username.text;
    passwordFromAddPacsView = self.password.text;
    wadoUrlFromAddPacsView =self.wadoUrl.text;
    loginWebService = self.apiDirectory.text;
    
     NSLog(@"Add button is working!");
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
    
 PacsServer *newPacsServer = [[PacsServer alloc] init];
//    
//    if(pacsDataArray.length > 0)
//    {
//        id jsonObject = [NSJSONSerialization JSONObjectWithData:[pacsDataArray dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//        
//        //  Type check because the JSON serializer can return an array or dictionary
//        if([jsonObject isKindOfClass:[NSMutableArray class]])
//        {
//        
//        newPacsServer.dataArrayIncludesUsernamePasswordWadoLoginWebServiceAndSecurity = jsonObject;
//        //
//       
//              }
//        [[PacsServerManager pacsManager].pacsServers addObject:newPacsServer];
//        NSLog(@"json obhect%@", jsonObject);
//  // _pickerData = jsonObject;
//    }
//  
//    
    
    newPacsServer.pacsName= pacsNameFromAddPacsView;
    newPacsServer.dataArrayIncludesUsernamePasswordWadoLoginWebServiceAndSecurity = pacsDataArray;
    [[PacsServerManager pacsManager].pacsServers addObject:newPacsServer];
     
    //NSLog(@"%@", [PacsServerManager pacsManager].pacsServers);
//    SettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
//   [self presentViewController:vc animated:YES completion:nil];
//    
    [self performSegueWithIdentifier:@"Save" sender:self];
  //[self.navigationController popViewControllerAnimated:YES];
    
}


@end
