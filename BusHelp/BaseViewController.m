//
//  BaseViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithRed:236.0f / 255.0f green:236.0f / 255.0f blue:236.0f / 255.0f alpha:1.0f];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)commonInit {
    
}

- (void)setupNavigationBar {
    if (self.tabBarController != nil) {
        self.tabBarController.navigationItem.title = self.tabBarItem.title;
        self.tabBarController.navigationItem.rightBarButtonItem.customView.hidden = YES;
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
        self.tabBarController.navigationItem.hidesBackButton = YES;
        self.tabBarController.navigationItem.leftBarButtonItem = nil;

    }
    if (self.navigationController.tabBarController != nil) {
        self.navigationController.tabBarController.navigationItem.title = self.navigationController.tabBarItem.title;
    }
}

@end
