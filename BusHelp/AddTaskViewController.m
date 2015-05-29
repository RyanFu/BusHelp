//
//  AddTaskViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/29.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "AddTaskViewController.h"
#import "TaskManagerListViewController.h"
#import "NotificationItem.h"
#import "DataRequest.h"
#import "CommonFunctionController.h"
#import "UserSettingInfo.h"


@interface AddTaskViewController ()
{
    NSString *Namestring;
    NSString *Useridstring;
    NSString *Org_id;
}
@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=@"新建任务";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"task-save"] style:UIBarButtonItemStylePlain target:self action:@selector(saveTask)];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveTask
{
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text=@"";
}

- (IBAction)managerViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"负责人");
    [self performSegueWithIdentifier:@"AddTaskToManagers" sender:self];

}

- (IBAction)vehicleViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"选择车辆");
    [self performSegueWithIdentifier:@"AddTaskToVehicles" sender:self];

}
- (IBAction)taskbegintimeViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"开始时间");

}
- (IBAction)taskendtimeViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"结束时间");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"AddTaskToManagers"]) {
        TaskManagerListViewController *managerlistvc=segue.destinationViewController;
        [managerlistvc setConfirmBlock:^(NSArray *select,NSString *OrgID){
            NotificationItem *item=[select objectAtIndex:0];
            Namestring=item.username;
            Useridstring=item.userid;
            Org_id=OrgID;
            NSLog(@"%@",Namestring);
            NSLog(@"%@",Useridstring);
            NSLog(@"%@",Org_id);
            self.managerLabel.text=Namestring;
            
        }];
    }
}


@end
