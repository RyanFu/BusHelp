//
//  TransmitNotificationViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/8.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "TransmitNotificationViewController.h"
#import "popOrgUsersViewController.h"
#import "NotificationItem.h"
#import "DataRequest.h"
#import "CommonFunctionController.h"
#import "UserSettingInfo.h"


@interface TransmitNotificationViewController ()
{
    NSMutableString *Name_multistring;
    NSMutableString *Userid_multistring;
    NSString *receiverString;
    NSString *Org_id;
}
@end

@implementation TransmitNotificationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Name_multistring=[[NSMutableString alloc]init];
    Userid_multistring=[[NSMutableString alloc]init];
    
}

- (void)setupNavigationBar
{
    [super setupNavigationBar];
    self.tabBarController.navigationItem.title = @"通知";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.tabBarController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    
    [self.ThemeField resignFirstResponder];
    [self.ContentText resignFirstResponder];
    
    if (Userid_multistring.length) {
        receiverString = [Userid_multistring substringWithRange:NSMakeRange(0, [Userid_multistring length]-1)];
    }
    NSLog(@"接收人:%@",receiverString);
    NSLog(@"主题:%@",self.ThemeField.text);
    NSLog(@"内容:%@",self.ContentText.text);
    NSLog(@"组织id:%@",Org_id);
    
    if ([CommonFunctionController checkValueValidate:receiverString]&&[CommonFunctionController checkValueValidate:self.ThemeField.text]&&[CommonFunctionController checkValueValidate:self.ContentText.text]&&[CommonFunctionController checkValueValidate:Org_id]) {
        [self postNotification:YES];
        [CommonFunctionController showAnimateHUDWithMessage:@"正在发送..."];

    }else
    {
        [CommonFunctionController showHUDWithMessage:@"请填写完整" detail:nil];
    }
    
}

-(void)postNotification:(BOOL)request
{
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest postNotification:receiverString org_id:Org_id message_title:self.ThemeField.text message_content:self.ContentText.text success:^(id data){
            [CommonFunctionController showHUDWithMessage:@"发送成功" success:YES];
             [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *message){
            NSLog(@"%@",message);
            [CommonFunctionController showHUDWithMessage:@"请填写完整" detail:nil];
        }];
    }else
    {
        [CommonFunctionController showHUDWithMessage:@"网络已断开" detail:nil];
    }
}


- (IBAction)addUser:(id)sender {
    [Name_multistring setString:@""];
    [Userid_multistring setString:@""];

    [self performSegueWithIdentifier:@"ToSelectUsers" sender:self];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"ToSelectUsers"]) {
        popOrgUsersViewController *pop=segue.destinationViewController;
        [pop setConfirmBlock:^(NSArray *select,NSString *OrgID){
//                NSLog(@"%@",select);
                for (int i=0; i<select.count; i++) {
                NotificationItem *item=[select objectAtIndex:i];
                [Name_multistring appendString:[NSString stringWithFormat:@"%@,",item.username]];
                [Userid_multistring appendString:[NSString stringWithFormat:@"%@,",item.userid]];
            }
            self.receiverLabel.text=Name_multistring;
            Org_id=OrgID;
            
        }];
    }
}



@end
