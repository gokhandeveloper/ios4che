//
//  DateSelectViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-11.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "DateSelectViewController.h"
#import "DatePickerViewController.h"
#import "Global.h"
#import "define.h"

@interface DateSelectViewController ()

@end

@implementation DateSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblDateSelect.delegate = self;
    self.tblDateSelect.dataSource = self;
    
    m_arrSelection = [[NSMutableArray alloc] initWithObjects:@"Any Date",@"Today",@"This Week",@"This Month", @"This Year", @"Custom", nil];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.tblDateSelect reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrSelection count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[Global sharedGlobal].filterDateType isEqualToString:CUSTOM] && (indexPath.row == 5)){
        NSLog(@"%d",(int)indexPath.row);
        return 150;
    }else{
        return 60;
    }
    
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 20)];
    
    if ([[Global sharedGlobal].filterDateType isEqualToString:CUSTOM]){
        
        if (indexPath.row == 5){
            

            UILabel *lblStartDate = [[UILabel alloc] initWithFrame:CGRectMake(50, 60, 70, 30)];
            lblStartDate.text = @"From :";
            CustomTextField *txtStart = [[CustomTextField alloc] initWithFrame:CGRectMake(120, 60, 170, 30)];
            txtStart.borderStyle = UITextBorderStyleRoundedRect;
            txtStart.delegate = self;
            txtStart.tag = 21;
            [cell addSubview:lblStartDate];
            [cell addSubview:txtStart];

           NSLog(@"%@",[Global sharedGlobal].strStartdDate);
           txtStart.text = [Global sharedGlobal].strStartdDate;
            [Global sharedGlobal].isFromStartDatePickerToDateSelect = NO;
            
//            if ([Global sharedGlobal].isFromStartDatePickerToDateSelect){
//                txtStart.text = [Global sharedGlobal].strSelectedDate;
//                [Global sharedGlobal].isFromStartDatePickerToDateSelect = NO;
//            }
            
            UILabel * lblEndDate = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 70, 30)];
            lblEndDate.text = @"To :";
            CustomTextField *txtEnd = [[CustomTextField alloc] initWithFrame:CGRectMake(120, 100, 170, 30)];
            txtEnd.borderStyle = UITextBorderStyleRoundedRect;
           txtEnd.delegate = self;
            txtEnd.tag = 22;
           [cell addSubview:lblEndDate];
           [cell addSubview:txtEnd];
            
           txtEnd.text = [Global sharedGlobal].strEndDate;
            [Global sharedGlobal].isFromEndDatePickerToDateSelect = NO;
            
//            if ([Global sharedGlobal].isFromEndDatePickerToDateSelect){
//                txtEnd.text = [Global sharedGlobal].strSelectedDate;
//                [Global sharedGlobal].isFromEndDatePickerToDateSelect = NO;
//            }
            
            lblTitle.text = m_arrSelection[indexPath.row];
            
        }else{
            lblTitle.text = m_arrSelection[indexPath.row];
        }
    }else{
        
        lblTitle.text = m_arrSelection[indexPath.row];
        
    }
    
    [cell addSubview:lblTitle];
    
    if ([[Global sharedGlobal].filterDateType isEqualToString:ANY_DATE] && (indexPath.row == 0)){
     
        cell.backgroundColor = [UIColor grayColor];
       
        
        
        
    }
    if ([[Global sharedGlobal].filterDateType isEqualToString:TODAY] && (indexPath.row == 1)){
      
        cell.backgroundColor = [UIColor grayColor];
      
      
        
        
    }
    if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_WEEK] && (indexPath.row == 2)){
     
        cell.backgroundColor = [UIColor grayColor];
   
        
        
        
    }
    if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_MONTH] && (indexPath.row == 3)){
     
        cell.backgroundColor = [UIColor grayColor];
      
      
 }
    
 

    if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_YEAR] && (indexPath.row == 4)){
       
        cell.backgroundColor = [UIColor grayColor];
        
    }
    if ([[Global sharedGlobal].filterDateType isEqualToString:CUSTOM] && (indexPath.row == 5)){
        cell.backgroundColor = [UIColor grayColor];
      
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0){
        [Global sharedGlobal].filterDateType = ANY_DATE;
        
        CustomTextField *txtEnd = [[CustomTextField alloc] initWithFrame:CGRectMake(120, 100, 170, 30)];
        txtEnd.text = [Global sharedGlobal].strStartdDate;
        
    }else if (indexPath.row == 1){
        [Global sharedGlobal].filterDateType = TODAY;

        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd"];

        NSString *dateString = [dateFormat stringFromDate:today];
        NSLog(@"date: %@", dateString);
      [Global sharedGlobal].strStartdDate =dateString;
        
        NSDate *todayAgagin = [NSDate date];
        NSString *dateStringAgain = [dateFormat stringFromDate:todayAgagin];
        NSLog(@"date: %@", dateStringAgain);
        [Global sharedGlobal].strEndDate = dateStringAgain;
        
        
    }else if (indexPath.row == 2){
         [Global sharedGlobal].filterDateType = THIS_WEEK;
         NSLog(@"%d",(int)indexPath.row);
        [Global sharedGlobal].strStartdDate = @"";
        [Global sharedGlobal].strEndDate = @"";
        NSDate *dateFromFilteringForThisWeek= [NSDate date];
        NSLog(@"%@", dateFromFilteringForThisWeek);
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents* components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:dateFromFilteringForThisWeek];
        NSDateComponents* componentsForEndDayOfTheCurrentWeek = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:dateFromFilteringForThisWeek];
        
        [components setDay:([components day] - ([components weekday]-1))];
        [componentsForEndDayOfTheCurrentWeek setDay:([components day] + (7 - [components weekday]))];
        [componentsForEndDayOfTheCurrentWeek setHour:23];
        [componentsForEndDayOfTheCurrentWeek setMinute:59];
        [componentsForEndDayOfTheCurrentWeek setSecond:59];
        int yearForThisWeek = (int) [components year];
        int monthForThisWeek = (int) [components month];
        int dayStartFromForThisWeek = (int) [components day];
        int dateEndForThisWeek = (int) [componentsForEndDayOfTheCurrentWeek day];
        
        NSLog(@"%d", dayStartFromForThisWeek);
        
        
        [Global sharedGlobal].strStartdDate = [NSString stringWithFormat:@"%d-%d-%d",yearForThisWeek,monthForThisWeek,dayStartFromForThisWeek];
        [Global sharedGlobal].strEndDate = [NSString stringWithFormat:@"%d-%d-%d",yearForThisWeek,monthForThisWeek,dateEndForThisWeek];
        NSLog(@"%@", [Global sharedGlobal].strStartdDate);
        NSLog(@"%@", [Global sharedGlobal].strEndDate);

        
    }else if (indexPath.row == 3){
        [Global sharedGlobal].filterDateType = THIS_MONTH;
        [Global sharedGlobal].strStartdDate = @"";
        [Global sharedGlobal].strEndDate = @"";
        NSDate *dateFromFilteringForThisMonth = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *components = [calendar components: unitFlags fromDate: dateFromFilteringForThisMonth];
        int yearForThisMonth = (int)[components year];
        int monthForThisMonth = (int)[components month];
        int dayStartFromForThisMonth = 01;
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
       NSUInteger numberOfDaysInMonth = rng.length;
      
        [Global sharedGlobal].strStartdDate =[ NSString stringWithFormat:@"%d-%d-%d",yearForThisMonth,monthForThisMonth,dayStartFromForThisMonth];
        [Global sharedGlobal].strEndDate = [NSString stringWithFormat:@"%d-%d-%lu",yearForThisMonth,monthForThisMonth,numberOfDaysInMonth];
        
            NSLog(@"%@", [Global sharedGlobal].strStartdDate);
            NSLog(@"%@", [Global sharedGlobal].strEndDate);
        
        
    }else if (indexPath.row == 4){
        [Global sharedGlobal].filterDateType = THIS_YEAR;
        [Global sharedGlobal].strStartdDate = @"";
        [Global sharedGlobal].strEndDate = @"";
        NSDate *dateFromFiltering = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *components = [calendar components: unitFlags fromDate: dateFromFiltering];
        int year = (int)[components year];
        int month = (int)[components month];
        int day = (int)[components day];
        int monthStartFrom = 1;
        int dayStartFrom = 1;
        [Global sharedGlobal].strStartdDate = [NSString stringWithFormat:@"%d-%d-%d",year,monthStartFrom,dayStartFrom];
        
        
        [Global sharedGlobal].strEndDate = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
        NSLog(@"%@", [Global sharedGlobal].strStartdDate);
        NSLog(@"%@", [Global sharedGlobal].strEndDate);
        
        
    }
    else{
        [Global sharedGlobal].filterDateType = CUSTOM;
        [Global sharedGlobal].strStartdDate = @"";
      [Global sharedGlobal].strEndDate = @"";
        NSLog(@"%@", [Global sharedGlobal].strStartdDate);
        NSLog(@"%@", [Global sharedGlobal].strEndDate);
    }
    
    [tableView reloadData];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    
}

- (void) TapEvent:(int)tag{
    
    if (tag == 21){
        [Global sharedGlobal].isFromStartDatePickerToDateSelect = YES;
        DatePickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tag == 22){
        [Global sharedGlobal].isFromEndDatePickerToDateSelect = YES;
        DatePickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
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

- (IBAction)doneAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)cancelAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
