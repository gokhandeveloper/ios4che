//
//  FilterViewController.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-01-28.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface FilterViewController : UIViewController<CustomTextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *txtPatientId;
@property (weak, nonatomic) IBOutlet UITextField *txtPatientName;

@property (weak, nonatomic) IBOutlet CustomTextField *txtDate;

@property (weak, nonatomic) IBOutlet CustomTextField *txtModality;

- (IBAction)rightButtonHandler:(id)sender;



@end
