//
//  StudyViewController.h
//  PACS
//
//  Created by Gokhan Dilek on 23/02/2015.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic)  IBOutlet UICollectionView* tblStudies;
@property (weak, nonatomic) IBOutlet UILabel* patientName;

@end
