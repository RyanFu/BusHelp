//
//  TaskPickVehiclesViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/29.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "TaskPickVehiclesViewController.h"
#import "DataRequest.h"
#import "Vehicle.h"

@interface TaskPickVehiclesViewController ()
{
    NSArray *_vehicleArray;
    Vehicle *_vehicle;
    NSMutableArray *selectArray;

}
@end

@implementation TaskPickVehiclesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vehicleTable.tableFooterView=[[UIView alloc]init];
    if ([DataFetcher fetchAllVehicle:YES].count) {
        _vehicleArray=[DataFetcher fetchAllVehicle:YES];
        [self.vehicleTable reloadData];
        
    }else
    {
        [self setupData];
    }
    self.vehicleTable.allowsMultipleSelectionDuringEditing=YES;
    [self.vehicleTable setEditing:YES];
    
    selectArray=[[NSMutableArray alloc]init];

}

-(void)setupData
{
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _vehicleArray = [NSMutableArray arrayWithArray:vehicleArray];
            [CommonFunctionController hideAllHUD];
            [self.vehicleTable reloadData];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _vehicleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    _vehicle=[_vehicleArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",_vehicle.number];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _vehicle=[_vehicleArray objectAtIndex:indexPath.row];
    [selectArray addObject:_vehicle];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _vehicle=[_vehicleArray objectAtIndex:indexPath.row];
    [selectArray removeObject:_vehicle];
}

-(void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=@"车辆";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonTap)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}

- (void)confirmButtonTap
{
    if (selectArray.count) {
        self.confirmBlock(selectArray);
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [CommonFunctionController showHUDWithMessage:@"请先选择车辆" detail:nil];
    }
    
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
