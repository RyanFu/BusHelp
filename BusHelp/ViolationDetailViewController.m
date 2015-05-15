//
//  ViolationDetailViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ViolationDetailViewController.h"
#import "ViolationPageView.h"

@interface ViolationDetailViewController ()

@end

@implementation ViolationDetailViewController
@synthesize vehicle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",vehicle);
    _violationPageview = [[[NSBundle mainBundle]loadNibNamed:@"ViolationPageView" owner:self options:nil]objectAtIndex:0];
    _violationPageview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _violationPageview.vehicle=vehicle;
}

- (void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=vehicle.number;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
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
