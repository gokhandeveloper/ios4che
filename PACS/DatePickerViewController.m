//
//  DatePickerViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-11.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "DatePickerViewController.h"
#import "Global.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem.title = @"Done";
    
}

- (IBAction)DoneAction:(id)sender {
    
    NSDate *dateFromPicker = [self.datePicker date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components: unitFlags fromDate: dateFromPicker];
    int year = (int)[components year];
    int month = (int)[components month];
    int day = (int)[components day];
    
    if ([Global sharedGlobal].isFromStartDatePickerToDateSelect){
        [Global sharedGlobal].strStartdDate = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    }
    if ([Global sharedGlobal].isFromEndDatePickerToDateSelect){
        [Global sharedGlobal].strEndDate = [NSString stringWithFormat:@"%d-%d-%d",year,month,day+1];
    }
    
//    [Global sharedGlobal].strStartdDate = [NSString stringWithFormat:@"%d-%d-%d",year,month,day+1];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)cancelAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
