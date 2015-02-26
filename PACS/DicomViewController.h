//
//  DicomViewController.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-09.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DicomViewController : UIViewController

{
    
    CGSize m_screenSize;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
