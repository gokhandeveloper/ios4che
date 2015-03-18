//
//  LoginViewController.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-01-18.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController<UITextFieldDelegate>

{
    
}

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtWadoUrl;
@property (weak, nonatomic) IBOutlet UITextField *txtWebServiceDirectory;
@property (weak, nonatomic) IBOutlet UISwitch *securitySwitch;

- (IBAction)loginAction:(id)sender;




@end
