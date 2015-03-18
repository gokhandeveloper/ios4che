//
//  UITabBarControllerViewController.m
//  com.ios4che
//
//  Created by gokhan on 16/03/2015.
//  Copyright (c) 2015 Gokhan DIlek. All rights reserved.
//

#import "UITabBarControllerViewController.h"

@interface UITabBarControllerViewController ()

@end

@implementation UITabBarControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
