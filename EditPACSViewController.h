//
//  EditPACSViewController.h
//  com.ios4che
//
//  Created by gokhan on 17/03/2015.
//  Copyright (c) 2015 Gokhan DIlek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPACSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *pacsName;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *wadoUrl;
@property (weak, nonatomic) IBOutlet UITextField *apiDirectory;

- (IBAction)saveForEditPacs:(id)sender;
@end
