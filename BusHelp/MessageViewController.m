//
//  MessageViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "MessageViewController.h"
#import "FunctionTableViewCell.h"
#import "DataFetcher.h"
#import "popoverViewController.h"
#import "ManagerViewController.h"
#import "DataRequest.h"
#import "CommonFunctionController.h"
#import "CreatOrJionViewController.h"
#import "UIView+MGBadgeView.h"

@interface MessageViewController ()
{
    NSArray *funclist;
    UIBarButtonItem *rightBarButtonItem;
    BOOL hasadd;
    popoverViewController *pop;
    NSString *messagecategory;
    NSString *tabbarTitle;
    Org *_org;
    NSInteger messageboxNum;
    NSInteger notificationNum;

}
@end

@implementation MessageViewController
@synthesize messageTable;

-(void)viewWillAppear:(BOOL)animated
{
    [self setupNavigationBar];
    if ([DataFetcher fetchAllOrg].count) {
        _org=[[DataFetcher fetchAllOrg] firstObject];
        [self setupNavigationBar];

    }else
    {
        if ([UserSettingInfo checkIsLogin]) {
            [self setupOrgWithRequest:YES];

        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:updateBadgeValueKey object:nil];
    if ([UserSettingInfo checkIsLogin]) {
        [self fetchMessageNumber];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    funclist=[NSArray arrayWithObjects:@"消息盒子",@"通知", nil];
    self.messageTable.tableFooterView=[[UIView alloc]init];
    
    
    hasadd=NO;
    
    pop=[[popoverViewController alloc]initWithNibName:@"popoverViewController" bundle:nil];
    [pop.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    __weak id weakself=self;
    pop.dismissAndPush=^(BOOL flag){
        hasadd=flag;
        [weakself performSegueWithIdentifier:@"MessageToTransmitNotification" sender:nil];
    };
    pop.dismiss=^(BOOL flag){
        hasadd=flag;
    };
    
}

-(void)fetchMessageNumber
{
    [CommonFunctionController showAnimateMessageHUD];
    if ([CommonFunctionController checkNetworkWithNotify:NO])
    {
        [DataRequest getMessageNumber:^(id data){
            messageboxNum=[[data objectForKey:@"messagebox_num"] integerValue];
            notificationNum=[[data objectForKey:@"notice_num"] integerValue];
            [messageTable reloadData];

            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
            
        }];
    }else{
        [CommonFunctionController showHUDWithMessage:@"网络未连接" success:NO];
    }
    
    
}

- (void)setupOrgWithRequest:(BOOL)request {
    [CommonFunctionController showAnimateMessageHUD];
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _org = [orgArray firstObject];
            NSLog(@"组织名称：%@",_org.name);
            [self setupNavigationBar];
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message){
            [CommonFunctionController hideAllHUD];

        }];
    }
    else {
        [CommonFunctionController showHUDWithMessage:@"网络已断开" detail:nil];
    }
}


- (void)setupNavigationBar {
    [super setupNavigationBar];
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postMyNotification)];

    if (_org.userType.integerValue==OrgUserTypeCreater||_org.userType.integerValue==OrgUserTypeAdmin) {
        self.tabBarController.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }else
    {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
}


-(void)postMyNotification
{
    if (hasadd==YES) {
        hasadd=NO;
        [pop.view removeFromSuperview];
    }else if(hasadd==NO)
    {
        hasadd=YES;
        [self.view addSubview:pop.view];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FunctionTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"FunctionTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    FunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor=[UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.FunctionLabel.text=[funclist objectAtIndex:indexPath.row];
    cell.FunctionImage.backgroundColor=[UIColor clearColor];

    if(indexPath.row==0)
    {
        if(messageboxNum==0)
        {
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-systemmessage"];
            [cell.FunctionImage.badgeView setBadgeValue:0];
            [cell.FunctionImage.badgeView setOutlineWidth:0];
            [cell.FunctionImage.badgeView setBadgeColor:[UIColor redColor]];
        }
        else {
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-systemmessage"];
            [cell.FunctionImage.badgeView setBadgeValue:messageboxNum];
            [cell.FunctionImage.badgeView setOutlineWidth:0];
            [cell.FunctionImage.badgeView setBadgeColor:[UIColor redColor]];
        }
        [cell.FunctionImage.badgeView setPosition:MGBadgePositionTopRight];

    }
    if (indexPath.row==1) {
        if(notificationNum==0)
        {
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-notification"];
            [cell.FunctionImage.badgeView setBadgeValue:0];
            [cell.FunctionImage.badgeView setOutlineWidth:0];
            [cell.FunctionImage.badgeView setBadgeColor:[UIColor redColor]];
        }
        else {
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-notification"];
            [cell.FunctionImage.badgeView setBadgeValue:notificationNum];
            [cell.FunctionImage.badgeView setOutlineWidth:0];
            [cell.FunctionImage.badgeView setBadgeColor:[UIColor redColor]];
        }
        [cell.FunctionImage.badgeView setPosition:MGBadgePositionTopRight];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            messagecategory=@"1001,2001,3001,5001";
            tabbarTitle=@"消息盒子";
            [self performSegueWithIdentifier:@"MessageToManger" sender:self];
            break;
        case 1:
            if (_org != nil && [_org.status integerValue] == OrgStatusJoined) {
                messagecategory=@"4001";
                tabbarTitle=@"通知";
                [self performSegueWithIdentifier:@"MessageToManger" sender:self];
                break;

            }else
            {
                [self CreateOrJoin];
            }
            
        default:
            break;
    }
}

//如果没有加入组织，点击通知跳转至我的团队
-(void)CreateOrJoin
{
    CreatOrJionViewController *createorjoinViewController=[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CreatOrJionViewController class])];
    [self.tabBarController.navigationController pushViewController:createorjoinViewController animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessageToManger"]) {
        ManagerViewController *managerVC=segue.destinationViewController;
        managerVC.MessageCategory=messagecategory;
        managerVC.TabbarTitle=tabbarTitle;
    }

}


@end
