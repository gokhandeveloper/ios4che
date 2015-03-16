//
//  LoginViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-01-18.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "define.h"
#import "Global.h"
@interface LoginViewController ()



@end

@implementation LoginViewController
@synthesize txtUsername, txtPassword, txtWadoUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtUsername.delegate = self;
    self.txtPassword.delegate = self;
    self.txtWadoUrl.delegate = self;
   // NSLog(@"Testing");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void) viewDidAppear:(BOOL)animated{
    
    
    
}


- (IBAction)loginAction:(id)sender {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"username": self.txtUsername.text,
                             @"password": self.txtPassword.text};
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *http , *wadoUrl , *portNumber, *seperator, *webServiceDirectory, *loginWebService;
    wadoUrl = self.txtWadoUrl.text;
    webServiceDirectory = self.txtWebServiceDirectory.text;
  
    
    
    if ([self.securitySwitch isOn]) {
        http = @"https:";
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString *wadoUrlKey= nil;
        NSString *webServiceDirectoryKey= nil;
        if (standardUserDefaults)
        wadoUrlKey = [standardUserDefaults objectForKey:@"wadoUrlStored"];
        webServiceDirectoryKey = [standardUserDefaults objectForKey:@"directoryStored"];
      
        portNumber = @":8443";
        seperator = @"/";
        webServiceDirectory = webServiceDirectory;
        loginWebService =@"/login.jsp";

      //  [self.securitySwitch setOn:NO animated:YES];
    } else {
        http = @"http:";
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults)
            
        {
            [standardUserDefaults setObject:wadoUrl forKey:@"wadoUrlStored"];
            [standardUserDefaults setObject:http forKey:@"hyptertextStored"];
            [standardUserDefaults setObject:portNumber forKey:@"portNumberStored"];
            [standardUserDefaults setObject:webServiceDirectory forKey:@"directoryStored"];
            [standardUserDefaults synchronize];
        }
        
        
        //  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString *wadoUrlKey= nil;
        NSString *webServiceDirectoryKey= nil;
        if (standardUserDefaults)
            wadoUrlKey = [standardUserDefaults objectForKey:@"wadoUrlStored"];
        webServiceDirectoryKey = [standardUserDefaults objectForKey:@"directoryStored"];
        
        portNumber = @":8080";
        seperator = @"/";
        webServiceDirectory = webServiceDirectory;
        //webServiceDirectory = @"/dicom-iphone";
        loginWebService =@"/login.jsp";

        
      //  [self.securitySwitch setOn:YES animated:YES];
    }
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        
    {
        [standardUserDefaults setObject:wadoUrl forKey:@"wadoUrlStored"];
        [standardUserDefaults setObject:http forKey:@"hyptertextStored"];
        [standardUserDefaults setObject:portNumber forKey:@"portNumberStored"];
        [standardUserDefaults setObject:webServiceDirectory forKey:@"directoryStored"];
        [standardUserDefaults synchronize];
    }
   //NSURL *url = [[NSURL alloc] initWithString:wadoUrl];
   // NSLog(@"%@" ,wadoUrl);
    
    NSArray *loginUrlParts = [[NSArray alloc] initWithObjects: http, wadoUrl, portNumber, seperator, webServiceDirectory, loginWebService ,nil];
    NSString *loginUrl = [loginUrlParts componentsJoinedByString:@""];
    
    [manager GET:loginUrl  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status)   {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
                }
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    
                    [self loginAction:(id)sender];
                    
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable:
                {
                    NSLog(@"AFNetworkReachabilityStatusNotReachable");// do whatever we wish when network is available
                    break;
                }
                default:              // do whatever we wish when network is not available
                    break;
            }
        }];

        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //get server response
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
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:nil
                                                         message:@"Something went wrong. Please check your connection."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
    
}


@end
