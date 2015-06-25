//
//  popoverViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "popoverViewController.h"

@interface popoverViewController ()

@end

@implementation popoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backgroundImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handletap:)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [self.backgroundImage addGestureRecognizer:tap];
}

-(void)handletap:(UITapGestureRecognizer *)sender
{
    [self.view removeFromSuperview];
    _dismiss(NO);
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

- (IBAction)postNotification:(id)sender {
    [self.view removeFromSuperview];
    _dismissAndPush(NO);

}
@end
