//
//  StudyViewController.m
//  PACS
//
//  Created by Gokhan Dilek on 23/02/2015.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "StudyViewController.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "AFHTTPRequestOperationManager.h"
#import "AsyncImageView.h"
#import "DicomShowViewController.h"
#import "define.h"
@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
    self.tblStudies.delegate = self;
self.tblStudies.dataSource = self;
    
   // NSString *patientNameAsTitle = self.title;
    //self.title=nil;
   self.title = [NSString stringWithFormat:@"%@", [Global sharedGlobal].patientNameTobePassedToOtherViewers];
   // self.navigationItem.title = [NSString stringWithFormat:@"%@", [Global sharedGlobal].strPatientName];
}


- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
 [self.navigationController setNavigationBarHidden:NO];
  
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"study_id": [NSString stringWithFormat:@"%d", [Global sharedGlobal].nStudyIDNum]};
    
    NSLog(@"%d", [Global sharedGlobal].nStudyIDNum);
    
    // NSLog(@"%@", [Global sharedGlobal].szPk);
    //  NSLog(@"can you hear me! Testing the console only");
    
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
        [self.tblStudies reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
    
  
//
}



#pragma collection view methods


-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    return [[[Global sharedGlobal]arrDicomData] count];
    


}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
         
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudyCell" forIndexPath:indexPath];
   
   
        
   //NSLog(@"can you hear me inside collecton view! Testing the console only");
    
   NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *wadoUrlKey= nil;
    NSString *portNumberKey =nil;
    NSString *hyperText = nil;
    if (standardUserDefaults)
   
        wadoUrlKey = [standardUserDefaults objectForKey:@"wadoUrlStored"];
    portNumberKey= [standardUserDefaults objectForKey:@"portNumberStored"];
    hyperText = [standardUserDefaults objectForKey:@"hyptertextStored"];
  NSString *seperator;
    seperator = @"/";
    
    
    
  //  UIImageView *imgDicom = (UIImageView *)[cell viewWithTag:1000];
   // NSDictionary *dictDicom = [Global sharedGlobal].arrDicomData[indexPath.row];
    
       AsyncImageView *imgDicom = [[AsyncImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@wado?requestType=WADO&studyUID=%@&seriesUID=%@&objectUID=%@",hyperText, wadoUrlKey, portNumberKey, seperator,  [Global sharedGlobal].arrDicomData[indexPath.row] [@"studyUID"],[Global sharedGlobal].arrDicomData[indexPath.row][@"seriesUID"],[Global sharedGlobal].arrDicomData[indexPath.row][@"objectUID"]]]]]];
   // imgDicom.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@wado?requestType=WADO&studyUID=%@&seriesUID=%@&objectUID=%@",hyperText, wadoUrlKey, portNumberKey, seperator, [Global sharedGlobal].arrDicomData[indexPath.row] [@"studyUID"],[Global sharedGlobal].arrDicomData[indexPath.row][@"seriesUID"],[Global sharedGlobal].arrDicomData[indexPath.row][@"objectUID"]]];
    
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:imgDicom.image];
  // cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@wado?requestType=WADO&studyUID=%@&seriesUID=%@&objectUID=%@",hyperText, wadoUrlKey, portNumberKey, seperator,  imgDicom[@"studyUID"],imgDicom[@"seriesUID"],imgDicom[@"objectUID"]]]]]];
    //  imgDicom.tag = 100;
        UILabel *patientLable = [[UILabel alloc] initWithFrame:CGRectMake(22, 20, 400, 30)];
    [patientLable setTextColor:[UIColor greenColor]];
        NSString *patientName = [Global sharedGlobal].patientNameTobePassedToOtherViewers;
    [patientLable setText:[NSString stringWithFormat:@"Patient Name:%@", patientName]];
  //  NSLog(@"%@", strPatientName);
        [cell.contentView addSubview:patientLable];
    
        UILabel *patientIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 25, 400, 60)];
    [patientIDLabel setTextColor:[UIColor greenColor]];
        NSString *patientIDLabelonImages = [Global sharedGlobal].patientIDTobePassedToOtherViewers;
    [patientIDLabel setText:[NSString stringWithFormat:@"Patient ID:%@", patientIDLabelonImages]];
    //  NSLog(@"%@", strPatientName);
        [cell.contentView addSubview:patientIDLabel];
    
    
    
        UILabel *patientDobLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 45, 400, 90)];
    [patientDobLabel setTextColor:[UIColor greenColor]];
        NSString *patientDobLabelOnImages = [Global sharedGlobal].patientDobTobePassedToOtherViewers;
    [patientDobLabel setText:[NSString stringWithFormat:@"DOB:%@", patientDobLabelOnImages]];
    
    [cell.contentView addSubview:patientDobLabel];
    
    if(![[Global sharedGlobal].patientSexTobePassedToOtherViewers isEqual:[NSNull null]])
    {
    UILabel *patientSexLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 75, 300, 60)];
    [patientSexLabel setTextColor:[UIColor greenColor]];
    NSString *patientSexLabelOnImages = [Global sharedGlobal].patientSexTobePassedToOtherViewers;
    [patientDobLabel setText:[NSString stringWithFormat:@"Sex:%@", patientSexLabelOnImages]];
    
    [cell.contentView addSubview:patientSexLabel];
    
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
   // imgDicom.userInteractionEnabled = YES;
    //imgDicom.tag = 100;
                          //    NSLog(@"%@",imgDicom);
 //   imgDicom.image = _studyImageView.image;
    
    
//    NSString *testing = [NSString stringWithFormat:@"my dictionary is %@", dictDicom];
//    
//    
//    NSLog(@"%@", testing);
    
   // NSDictionary *dictDicom = [Global sharedGlobal].arrDicomData[indexPath.row];
    //UIImage *imgD = [UIImage imageWithData:[NSData da]
    
    //UIImage *imgDicom = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@wado?requestType=WADO&studyUID=%@&seriesUID=%@&objectUID=%@",hyperText, wadoUrlKey, portNumberKey, seperator,  dictDicom[@"studyUID"],dictDicom[@"seriesUID"],dictDicom[@"objectUID"]]]]];
//    NSLog(@"%@",imgDicom);
    //

    
   //1 NSDictionary *dictDicom = [Global sharedGlobal].arrDicomData[indexPath.row];
    
 //   imgDicom.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@wado?requestType=WADO&studyUID=%@&seriesUID=%@&objectUID=%@",hyperText, wadoUrlKey, portNumberKey, seperator,  dictDicom[@"studyUID"],dictDicom[@"seriesUID"],dictDicom[@"objectUID"]]];
    
   
 // UIImageView *imgDicom = (UIImageView *)[cell viewWithTag:100];
    
 
    
//UIImageView *studyImageView =(UIImageView *)[cell viewWithTag:100];
 
    
  //  [self.view addSubview:_studyImageView];
   // imgDicom.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@wado?requestType=WADO&studyUID=%@&seriesUID=%@&objectUID=%@",hyperText, wadoUrlKey, portNumberKey, seperator,  dictDicom[@"studyUID"],dictDicom[@"seriesUID"],dictDicom[@"objectUID"]]]]];
  

//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    imgView.image = [UIImage imageNamed:@"image.png"];
//    cell.imageView.image = imgView.image;
    
    
  // [cell addSubview:imgDicom];
    
return cell;
   
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
    
{
    
 //   UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
      [Global sharedGlobal]. imageNumber = (int) indexPath.row;
    
    NSLog(@"%d", [Global sharedGlobal].imageNumber);
    
    DicomShowViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DicomShowViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
@end
