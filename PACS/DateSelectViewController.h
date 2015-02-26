//
//  DateSelectViewController.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-11.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface DateSelectViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomTextFieldDelegate>

{
    NSMutableArray *m_arrSelection;
}

@property (weak, nonatomic) IBOutlet UITableView *tblDateSelect;

- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;


@end
