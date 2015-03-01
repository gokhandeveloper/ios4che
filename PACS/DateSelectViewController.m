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
        [Global sharedGlobal].strStartdDate = @"";
        [Global sharedGlobal].strEndDate = @"";
        cell.backgroundColor = [UIColor grayColor];
    }
    if ([[Global sharedGlobal].filterDateType isEqualToString:TODAY] && (indexPath.row == 1)){
        [Global sharedGlobal].strStartdDate = @"";
        [Global sharedGlobal].strEndDate = @"";
        cell.backgroundColor = [UIColor grayColor];
    }
    if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_WEEK] && (indexPath.row == 2)){
        [Global sharedGlobal].strStartdDate = @"";
        [Global sharedGlobal].strEndDate = @"";
        cell.backgroundColor = [UIColor grayColor];
    }
    if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_MONTH] && (indexPath.row == 3)){
        [Global sharedGlobal].strStartdDate = @"";
        [Global sharedGlobal].strEndDate = @"";
        cell.backgroundColor = [UIColor grayColor];
    }
    if ([[Global sharedGlobal].filterDateType isEqualToString:THIS_YEAR] && (indexPath.row == 4)){
        [Global sharedGlobal].strStartdDate = @"";
        [Global sharedGlobal].strEndDate = @"";
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
    }else if (indexPath.row == 2){
        [Global sharedGlobal].filterDateType = THIS_WEEK;
    }else if (indexPath.row == 3){
        [Global sharedGlobal].filterDateType = THIS_MONTH;
    }else if (indexPath.row == 4){
        [Global sharedGlobal].filterDateType = THIS_YEAR;
    }
    else{
        [Global sharedGlobal].filterDateType = CUSTOM;
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
