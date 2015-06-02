//
//  HigerVehicleListViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/22.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "HigerVehicleListViewController.h"
#import "DataRequest.h"
#import "Vehicle.h"

@interface HigerVehicleListViewController ()
{
    NSArray *_vehicleArray;
    Vehicle *_vehicle;
    NSMutableArray *higerVehicle;
}
@end

@implementation HigerVehicleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    higerVehicle=[[NSMutableArray alloc]init];
    self.HigerListTable.tableFooterView=[[UIView alloc]init];
    
    if ([DataFetcher fetchAllVehicle:YES].count) {
        _vehicleArray=[DataFetcher fetchAllVehicle:YES];
        [higerVehicle removeAllObjects];
        for (int i=0; i<_vehicleArray.count; i++) {
            _vehicle=[_vehicleArray objectAtIndex:i];
            if ([_vehicle.identify_status isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)AuthenticationTypeHiger]]) {
                [higerVehicle addObject:_vehicle];
            }
        }
        [self.HigerListTable reloadData];

    }else
    {
        [self setupData];
    }


}

-(void)setupData
{
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _vehicleArray = [NSMutableArray arrayWithArray:vehicleArray];
            [higerVehicle removeAllObjects];
            for (int i=0; i<_vehicleArray.count; i++) {
                _vehicle=[_vehicleArray objectAtIndex:i];
                if ([_vehicle.identify_status isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)AuthenticationTypeHiger]]) {
                    [higerVehicle addObject:_vehicle];
                }
            }
            [CommonFunctionController hideAllHUD];
            [self.HigerListTable reloadData];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
    
}

-(void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=@"G-BOS车";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return higerVehicle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    _vehicle=[higerVehicle objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",_vehicle.number];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _vehicle=[higerVehicle objectAtIndex:indexPath.row];
    self.dismiss(_vehicle);
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
