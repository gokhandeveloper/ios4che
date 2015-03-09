//
//  MainViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-01-28.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "LoginViewController.h"
#import "DicomViewController.h"
#import "define.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblPatients.delegate = self;
    self.tblPatients.dataSource = self;
    
    m_arrPatient = [[NSMutableArray alloc] init];
  
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:ISLOGGED_IN]){
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
  
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
   NSString *wadoUrlKey = nil;
   NSString *webServiceDirectoryKey = nil;
    
    if (standardUserDefaults)
       wadoUrlKey = [standardUserDefaults objectForKey:@"wadoUrlStored"];
       webServiceDirectoryKey = [standardUserDefaults objectForKey:@"directoryStored"];
        _wadoUrl = wadoUrlKey;
        _webServiceDirectoryFromLogin = webServiceDirectoryKey;
    
    NSString *http , *wadoUrl , *portNumber, *webServiceDirectoryFromLogin, *patientSearchWebService;
    patientSearchWebService = @"patient_search.jsp";
    NSArray *patientSearchUrlParts = [[NSArray alloc] initWithObjects: http, wadoUrl, portNumber, webServiceDirectoryFromLogin, patientSearchWebService ,nil];
    NSString *patientSearchUrl = [patientSearchUrlParts componentsJoinedByString:@""];
    NSURL *patientSearchUrlConvertedfromStringToUrl = [NSURL URLWithString:patientSearchUrl];

    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:patientSearchUrlConvertedfromStringToUrl];
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)   {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                
                [self loginAction];
                
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
    
    [manager.reachabilityManager startMonitoring];
    
}

- (void) loginAction{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"%@", [Global sharedGlobal].strPatientId);
    NSLog(@"%@", [Global sharedGlobal].strPatientName);
    NSLog(@"%@", [Global sharedGlobal].strStartdDate);
    NSLog(@"%@", [Global sharedGlobal].strEndDate);
    NSLog(@"%@", [Global sharedGlobal].strModality);
    NSLog(@"%@", [Global sharedGlobal].filterDateType);
    NSLog(@"%@", [Global sharedGlobal].stIDNum);
   
    
    NSString *strPatientId = [Global sharedGlobal].strPatientId;
    NSString *strPatientName = [Global sharedGlobal].strPatientName;
    NSString *strStartdDate = [Global sharedGlobal].strStartdDate;
    NSString *strEndDate = [Global sharedGlobal].strEndDate;
    NSString *strModality = [Global sharedGlobal].strModality;
    NSString *filterDateType = [Global sharedGlobal].filterDateType;
    NSString *stIdNum =[Global sharedGlobal].stIDNum;
    
    if ([[Global sharedGlobal].strModality isEqualToString:@"ALL"]){
        strModality = @"";
    }
    
    NSDictionary *params = @{@"patient_id": strPatientId,
                             @"patient_name": strPatientName,
                             @"date_from": strStartdDate,
                             @"date_to": strEndDate,
                             @"modality": strModality,
                             @"date_type": filterDateType,
                             @"study_pk": stIdNum
                             };
       NSLog(@"%@", [[Global sharedGlobal] strPatientName]);
     
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
     
    //send request to server with parameters
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *wadoUrlKey = nil;
    NSString *webServiceDirectoryKey = nil;
    NSString *portNumberKey =nil;
    NSString *hyperText = nil;
    if (standardUserDefaults)
        wadoUrlKey = [standardUserDefaults objectForKey:@"wadoUrlStored"];
    webServiceDirectoryKey = [standardUserDefaults objectForKey:@"directoryStored"];
    portNumberKey= [standardUserDefaults objectForKey:@"portNumberStored"];
    hyperText = [standardUserDefaults objectForKey:@"hyptertextStored"];
    NSString *patientSearchWebService, *seperator;
    patientSearchWebService = @"patient_search.jsp";
    seperator = @"/";
    NSArray *patientSearchUrlParts = [[NSArray alloc] initWithObjects: hyperText, wadoUrlKey, portNumberKey, seperator, webServiceDirectoryKey, seperator, patientSearchWebService ,nil];
    NSString *patientSearchUrl = [patientSearchUrlParts componentsJoinedByString:@""];
    NSLog(@"patient search: %@", patientSearchUrl);
    [manager POST:patientSearchUrl  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
     
        m_arrPatient = responseObject;
     
        // show filtered data in the tableview
     
        [self.tblPatients reloadData];
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
     }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@", [Global sharedGlobal].strStartdDate);
    NSLog(@"%@", [Global sharedGlobal].strEndDate);
    NSLog(@"%lu", (unsigned long)m_arrPatient.count);
    return [m_arrPatient count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);     
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
  // NSSortDescriptor *m_arrPatient = [[NSSortDescriptor alloc] initWithKey:@"patient_pk" ascending:YES];
    
  //  for (int i=0; i< m_arrPatient[szPk] i++)
   // {
       // NSString *szPk = [[m_arrPatient objectAtIndex:i] objectForKey: @"patient_pk" ];
        //NSString *szPk = [[m_arrPatient[indexPath.row][@"patient_pk"] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet]] componentsJoinedByString:@" "];
    
  //  NSString *szPk = [[m_arrPatient objectAtIndex:0] objectForKey: ];
   
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"study_pk.intValue" ascending:YES];
   NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    
    m_arrPatientSortedByStudyPk = [m_arrPatient sortedArrayUsingDescriptors:sortDescriptors];
                                 
        NSString *strPatientName = [[m_arrPatientSortedByStudyPk[indexPath.row][@"patient_name"] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"]  invertedSet]] componentsJoinedByString:@" "];
        cell.textLabel.text = [NSString stringWithFormat:@"%@\nStudy Date: %@\nModality: %@", strPatientName, m_arrPatientSortedByStudyPk[indexPath.row][@"study_datetime"], m_arrPatientSortedByStudyPk[indexPath.row] [@"study_mods"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSLog(@"can you hear me table view! Testing the console only");
   // }
    
 
    
    cell.textLabel.numberOfLines = 3;
   // cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",strPatientName ,m_arrPatient[indexPath.row][@"study_datetime"], m_arrPatient[indexPath.row] [@"study_mods"]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
  
 //   NSLog(@"%d", _nPatientPkNum);
    
 //  [[Global sharedGlobal]. szPk intValue] = (int)indexPath.row;
    
    NSString *studyIDtoBePassed = [[m_arrPatientSortedByStudyPk[indexPath.row][@"study_pk"] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet]] componentsJoinedByString:@""];
    
    [Global sharedGlobal]. nStudyIDNum = [studyIDtoBePassed intValue];
    
    NSString *patientNametoBePassed = [[m_arrPatientSortedByStudyPk[indexPath.row] [@"patient_name"]componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet]] componentsJoinedByString:@" "];
//    
   [Global sharedGlobal] . patientNameTobePassedToOtherViewers  =[NSString stringWithFormat:@"%@", patientNametoBePassed ];
//    
    NSString *patientIDtoBePassed = [[m_arrPatientSortedByStudyPk[indexPath.row] [@"patient_id"]componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet]] componentsJoinedByString:@""];
    //
    [Global sharedGlobal] . patientIDTobePassedToOtherViewers  =[NSString stringWithFormat:@"%@", patientIDtoBePassed];
    //
 NSString *patientDobtoBePassed = [[m_arrPatientSortedByStudyPk[indexPath.row] [@"date_of_birth"] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet]] componentsJoinedByString:@""];
//    //
 [Global sharedGlobal] . patientDobTobePassedToOtherViewers  =[NSString stringWithFormat:@"%@", patientDobtoBePassed ];
//    //
    
    if (![m_arrPatientSortedByStudyPk[indexPath.row][@"patient_sex"] isEqual:[NSNull null]])
        
    {
    NSString *patientSextoBePassed = [[m_arrPatientSortedByStudyPk[indexPath.row] [@"patient_sex"]componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZqazwsxedcrfvtgbyhnujmik "] invertedSet]] componentsJoinedByString:@""];
    //
    [Global sharedGlobal] . patientSexTobePassedToOtherViewers  =[NSString stringWithFormat:@"%@", patientSextoBePassed ];
    //
    }

    DicomViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyViewController"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
