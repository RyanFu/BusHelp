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
#import "TaskPickVehiclesViewController.h"
#import "MyDataPickerView.h"
#define PICKERVIEW_HEIGHT 206
#define TOP_HEIGHT 64

@interface AddTaskViewController ()
{
    NSString *Namestring;
    NSString *Useridstring;
    NSString *Org_id;
    NSMutableString *vehicleids_Mutistring;
    NSMutableString *vehicleNumbers_Mutistring;
    MyDataPickerView *pickerview;
    NSString *vehicles_string;//final
}
@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    vehicleids_Mutistring=[[NSMutableString alloc]init];
    vehicleNumbers_Mutistring=[[NSMutableString alloc]init];
    vehicles_string=@"";
    
    pickerview=[[[NSBundle mainBundle]loadNibNamed:@"MyDataPickerView" owner:self options:nil]firstObject];
    [pickerview setFrame:CGRectMake(0, sFrame.size.height, sFrame.size.width, PICKERVIEW_HEIGHT)];
    [self.view addSubview:pickerview];
    
    pickerview.DataTimePickerView.date=[NSDate date];
    __weak MyDataPickerView *weakpickview=pickerview;
    [weakpickview setConfirmBlock:^(NSString *currentDate){
        NSLog(@"确定");
        if ([weakpickview.type isEqualToString:@"start"]) {
            self.beginTimeLabel.text=currentDate;
        }else if([weakpickview.type isEqualToString:@"end"])
        {
            self.endTimeLabel.text=currentDate;
        }
        [UIView animateWithDuration:0.5 animations:^{
            [weakpickview setFrame:CGRectMake(0, sFrame.size.height-TOP_HEIGHT, sFrame.size.width, PICKERVIEW_HEIGHT)];
        }];

        
    }];
    [weakpickview setCancelBlock:^(){
        NSLog(@"取消");
        [UIView animateWithDuration:0.5 animations:^{
            [weakpickview setFrame:CGRectMake(0, sFrame.size.height-TOP_HEIGHT, sFrame.size.width, PICKERVIEW_HEIGHT)];
        }];
    }];
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
    [self.taskTitle resignFirstResponder];
    [self.taskContent resignFirstResponder];
    if ([CommonFunctionController checkValueValidate:self.taskTitle.text]&&[CommonFunctionController checkValueValidate:self.taskContent.text]&&[CommonFunctionController checkValueValidate:self.managerLabel.text]&&[CommonFunctionController checkValueValidate:self.beginTimeLabel.text]&&[CommonFunctionController checkValueValidate:self.endTimeLabel.text]) {
        if (![self compareDate:self.beginTimeLabel.text endDate:self.endTimeLabel.text]) {
            [CommonFunctionController showHUDWithMessage:@"请检查您的日期" detail:nil];
        }else
        {
            [CommonFunctionController showAnimateHUDWithMessage:@"提交中.."];
            [DataRequest saveNewTask:@"" org_id:Org_id task_title:self.taskTitle.text task_content:self.taskContent.text task_manager:Useridstring task_begin_time:self.beginTimeLabel.text task_end_time:self.endTimeLabel.text vehicle_ids:vehicles_string success:^(id data){
                [self.navigationController popViewControllerAnimated:YES];
                [CommonFunctionController showHUDWithMessage:@"提交成功" success:YES];
            } failure:^(NSString *message){
                NSLog(@"error");
                [CommonFunctionController showHUDWithMessage:message detail:nil];

            }];
        }
        
    }else
    {
        [CommonFunctionController showHUDWithMessage:@"请填写完整" detail:nil];
    }
}

-(BOOL)compareDate:(NSString *)beginstring endDate:(NSString *)endstring
{
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *begindate=[df dateFromString:beginstring];
    NSDate *enddate=[df dateFromString:endstring];
    NSComparisonResult rs=[begindate compare:enddate];
    if (rs==NSOrderedDescending) {
        return NO;
    }else
    {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text=@"";
    [self hidePickerView:YES];
}

- (IBAction)managerViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"负责人");
    [self hidePickerView:YES];
    [self performSegueWithIdentifier:@"AddTaskToManagers" sender:self];

}

- (IBAction)vehicleViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"选择车辆");
    [self hidePickerView:YES];
    [vehicleids_Mutistring setString:@""];
    [vehicleNumbers_Mutistring setString:@""];
    [self performSegueWithIdentifier:@"AddTaskToVehicles" sender:self];

}
- (IBAction)taskbegintimeViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"开始时间");
    [self hidePickerView:NO];
    pickerview.type=@"start";

}
- (IBAction)taskendtimeViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"结束时间");
    [self hidePickerView:NO];
    pickerview.type=@"end";

}

- (void)hidePickerView:(BOOL)flag
{
    if (flag) {
        [UIView animateWithDuration:0.5 animations:^{
            [pickerview setFrame:CGRectMake(0, sFrame.size.height-TOP_HEIGHT, sFrame.size.width, PICKERVIEW_HEIGHT)];
        }];

    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [pickerview setFrame:CGRectMake(0, sFrame.size.height-TOP_HEIGHT-PICKERVIEW_HEIGHT, sFrame.size.width, PICKERVIEW_HEIGHT)];
        }];
    }
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
            if (select.count) {
                NotificationItem *item=[select objectAtIndex:0];
                Namestring=item.username;
                Useridstring=item.userid;
                Org_id=OrgID;
                NSLog(@"%@",Namestring);
                NSLog(@"%@",Useridstring);
                NSLog(@"%@",Org_id);
                self.managerLabel.text=Namestring;
            }
            
        }];
    }
    else if ([segue.identifier isEqualToString:@"AddTaskToVehicles"]) {
        TaskPickVehiclesViewController *vehiclesVC=segue.destinationViewController;
        [vehiclesVC setConfirmBlock:^(NSArray *selectArray){
            for (int i=0; i<selectArray.count; i++) {
                Vehicle *_vehicle=[selectArray objectAtIndex:i];
                [vehicleids_Mutistring appendString:[NSString stringWithFormat:@"%@,",_vehicle.vehicleID]];
                [vehicleNumbers_Mutistring appendString:[NSString stringWithFormat:@"%@,",_vehicle.number]];
            }
            NSLog(@"%@",vehicleids_Mutistring);
            NSLog(@"%@",vehicleNumbers_Mutistring);
            if (vehicleNumbers_Mutistring.length) {
                self.vehicleNumbersLabel.text=[vehicleNumbers_Mutistring substringWithRange:NSMakeRange(0,[vehicleNumbers_Mutistring length]-1)];
            }
            if (vehicleids_Mutistring.length) {
                vehicles_string=[vehicleids_Mutistring substringWithRange:NSMakeRange(0,[vehicleids_Mutistring length]-1)];
            }

            
        }];
    }

}


@end
