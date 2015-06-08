//
//  popOrgUsersViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/8.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "popOrgUsersViewController.h"
#import "DataRequest.h"
#import "CommonFunctionController.h"
#import "UserSettingInfo.h"
#import "ContactsTableViewCell.h"
#import "NotificationItem.h"

@interface popOrgUsersViewController ()
{
    NSArray *contactlist;
    NSArray *_orgArray;
    Org *_org;
    NSMutableArray *selectArray;

}
@end

@implementation popOrgUsersViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self setupNavigationBar];
    
    [self setupOrgWithRequest:YES];

}

- (void)setupNavigationBar
{
    [super setupNavigationBar];
    self.tabBarController.navigationItem.title = @"成员";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.tabBarController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirm)];

    
}

-(void)confirm
{
//    NSLog(@"%@",selectArray);
    _confirmBlock(selectArray,_org.orgID);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupOrgWithRequest:(BOOL)request {
    [CommonFunctionController showAnimateMessageHUD];
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _orgArray = orgArray;
            _org = [_orgArray firstObject];
            NSLog(@"组织id：%@",_org.orgID);
            if (_org) {
                [self getOrgAllUsers:YES];
            }else
            {
                [CommonFunctionController showHUDWithMessage:@"请先加入组织" detail:nil];
            }
            
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message detail:nil];
        }];
    }
    else {
        [CommonFunctionController showHUDWithMessage:@"网络已断开" detail:nil];

    }
}

-(void)getOrgAllUsers:(BOOL)request
{
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest getOrgAllUser:_org.orgID success:^(id data){
            contactlist=data;
//            NSLog(@"%@",contactlist);
            
            self.items = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<contactlist.count; i++) {
                NotificationItem *item = [[NotificationItem alloc] init];
                item.username = [NSString stringWithFormat:@"%@",[[contactlist objectAtIndex:i] objectForKey:@"user_name"]];
                item.userid = [NSString stringWithFormat:@"%@",[[contactlist objectAtIndex:i] objectForKey:@"user_id"]];
                [_items addObject:item];
            }

            [self.OrgUsersTable reloadData];
            [CommonFunctionController hideAllHUD];

        }  failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message detail:nil];
        }];
    }
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactlist count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactsTableViewCell";
    
    ContactsTableViewCell *cell = (ContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [cell.textLabel.font fontWithSize:17];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (contactlist.count>0) {
        cell.textLabel.text = [[contactlist objectAtIndex:indexPath.row]objectForKey:@"user_name"];

    }else
    {
        cell.textLabel.text=@"";
    }
    
    return cell;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationItem *item=[_items objectAtIndex:indexPath.row];
    [selectArray addObject:item];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationItem *item=[_items objectAtIndex:indexPath.row];
    [selectArray removeObject:item];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.OrgUsersTable.allowsMultipleSelectionDuringEditing=YES;
    [self.OrgUsersTable setEditing:YES]; //////设置uitableview为编译状态
    
    selectArray=[[NSMutableArray alloc]init];
    
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
