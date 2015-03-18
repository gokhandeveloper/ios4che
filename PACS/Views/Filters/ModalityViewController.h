//
//  ModalityViewController.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-11.
//  Copyright (c) 2015 John Catliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *m_arrModality;
}

@property (weak, nonatomic) IBOutlet UITableView *tblModality;

@end
