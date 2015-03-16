//
//  FilterViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-01-28.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "FilterViewController.h"
#import "Global.h"
#import "define.h"
#import "CustomTextField.h"
#import "MainViewController.h"
#import "ModalityViewController.h"
#import "DateSelectViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //customize navigation bar
    
    [self.navigationController setNavigationBarHidden:NO];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style: UIBarButtonItemStyleDone target:self action:@selector(leftButtonHandler:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
  UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonHandler:) ];
    self.navigationItem.rightBarButtonItem = rightButton;
    
  
    
    self.txtDate.delegate = self;
    self.txtModality.delegate = self;
    
    
    
    /*
    if ([Global sharedGlobal].isFromDatePickerToStartDate){
        self.txtDateFrom.text = [Global sharedGlobal].strSelectedDate;
        [Global sharedGlobal].isFromDatePickerToStartDate = NO;
    }
    if ([Global sharedGlobal].isFromDatePickerToEndDate){
        self.txtDateTo.text = [Global sharedGlobal].strSelectedDate;
        [Global sharedGlobal].isFromDatePickerToEndDate = NO;
    }
     */
    
    if ([[Global sharedGlobal].filterDateType isEqualToString:ANY_DATE]){
        self.txtDate.text = ANY_DATE;
    }else if ([[Global sharedGlobal].filterDateType isEqualToString:TODAY]){
        self.txtDate.text = TODAY;
    }else if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_WEEK]){
        self.txtDate.text = THIS_WEEK;
    }else if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_MONTH]){
        self.txtDate.text = THIS_MONTH;
    }
    else if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_YEAR]){
        self.txtDate.text = THIS_YEAR;
    }
    else if ([[Global sharedGlobal].filterDateType isEqualToString:CUSTOM]){
        self.txtDate.text = [NSString stringWithFormat:@"%@ - %@",[Global sharedGlobal].strStartdDate,[Global sharedGlobal].strEndDate];
    }

//    if ([Global sharedGlobal].isFromModalityPickerToFilter){
        self.txtModality.text = [Global sharedGlobal].strModality;
//        [Global sharedGlobal].isFromModalityPickerToFilter = NO;
//    }
}

- (void) leftButtonHandler: (UINavigationItem *) item {
 
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) rightButtonHandler: (UINavigationItem *) item {

    //save filter condition to singleton
    
    [Global sharedGlobal].strPatientId = self.txtPatientId.text;
    [Global sharedGlobal].strPatientName = self.txtPatientName.text;
    if ([self.txtModality.text isEqualToString:@"ALL"]){
        [Global sharedGlobal].strModality = @"";
    }else{
        [Global sharedGlobal].strModality = self.txtModality.text;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) TapEvent:(int) tag{
    
    if (tag == 11){
//        [Global sharedGlobal].isFromDatePickerToStartDate = YES;
        DateSelectViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tag == 12){
//        [Global sharedGlobal].isFromModalityPickerToFilter = YES;
        ModalityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalityViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
