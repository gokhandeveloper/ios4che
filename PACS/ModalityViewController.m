//
//  ModalityViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-11.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "ModalityViewController.h"
#import "Global.h"

@interface ModalityViewController ()

@end

@implementation ModalityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblModality.delegate = self;
    self.tblModality.dataSource = self;
    
    m_arrModality = [[NSMutableArray alloc] initWithObjects:@"ALL",@"CT",@"DR", @"MR",@"XA",@"CR",@"SE",@"NM",@"RF",@"DX",@"US",@"PX",@"OT", nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrModality count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = m_arrModality[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [Global sharedGlobal].strModality = m_arrModality[(int)indexPath.row];
//    [Global sharedGlobal].isFromModalityPickerToFilter = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
