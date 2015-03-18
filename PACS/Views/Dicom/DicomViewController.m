//
//  DicomViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-09.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "DicomViewController.h"
#import "DicomShowViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "define.h"
#import "AsyncImageView.h"

@interface DicomViewController ()

@end

@implementation DicomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tblDicom.delegate = self;
//    self.tblDicom.dataSource = self;
    
    
    m_screenSize = [UIScreen mainScreen].bounds.size;
  
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"study_id": [NSString stringWithFormat:@"%d", [Global sharedGlobal].nStudyIDNum]};
    
    NSLog(@"%d", [Global sharedGlobal].nStudyIDNum);
    
   // NSLog(@"%@", [Global sharedGlobal].szPk);

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
    NSString *dicomSearchWebService, *seperator;
    dicomSearchWebService = @"dicom_image.jsp";
    seperator = @"/";
    NSArray *dicomSearchUrlParts = [[NSArray alloc] initWithObjects: hyperText, wadoUrlKey, portNumberKey, seperator, webServiceDirectoryKey, seperator, dicomSearchWebService ,nil];
    NSString *dicomSearchUrl = [dicomSearchUrlParts componentsJoinedByString:@""];
    NSLog(@"patient search: %@", dicomSearchUrl);
    [manager POST:dicomSearchUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",responseObject);
    
        [Global sharedGlobal].arrDicomData = responseObject;
    
        [self addDicomImageViewToScrollView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
    
    
}

- (void) addDicomImageViewToScrollView{
    
    self.scrollView.contentSize = CGSizeMake(m_screenSize.width, ([Global sharedGlobal].arrDicomData.count / DicomRowCount) * m_screenSize.width/ DicomRowCount);
    
    for (int i = 0; i < [Global sharedGlobal].arrDicomData.count;i++){
        
        CGRect frame = CGRectMake((i % DicomRowCount) * m_screenSize.width / DicomRowCount, (i / DicomRowCount) * m_screenSize.width /DicomRowCount, m_screenSize.width / 3, m_screenSize.width / 3);
        AsyncImageView *imgDicom = [[AsyncImageView alloc] initWithFrame:frame];
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString *wadoUrlKey = nil;
        NSString *portNumberKey =nil;
        NSString *hyperText = nil;
        if (standardUserDefaults)
        
            wadoUrlKey = [standardUserDefaults objectForKey:@"wadoUrlStored"];
            portNumberKey= [standardUserDefaults objectForKey:@"portNumberStored"];
            hyperText = [standardUserDefaults objectForKey:@"hyptertextStored"];
            NSString *seperator;
            seperator = @"/";
        
        NSDictionary *dictDicom = [Global sharedGlobal].arrDicomData[i];
        
        imgDicom.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@wado?requestType=WADO&studyUID=%@&seriesUID=%@&objectUID=%@",hyperText, wadoUrlKey, portNumberKey, seperator,  dictDicom[@"studyUID"],dictDicom[@"seriesUID"],dictDicom[@"objectUID"]]];
        imgDicom.tag = i;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgDicom:)];
        [imgDicom addGestureRecognizer:tapGesture];
        imgDicom.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgDicom];
    }
         
}

- (void) tapImgDicom:(UITapGestureRecognizer *) gesture{
    
    int nTagNum = (int)gesture.view.tag;
    [Global sharedGlobal].nDicomIndex = nTagNum;
    
    DicomShowViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DicomShowViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
     
     
/*

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrDicomData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [Global sharedGlobal].nPatientId = (int)indexPath.row;
    
    DicomViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DicomViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
