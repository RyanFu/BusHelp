//
//  SelectVehicleViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "SelectVehicleViewController.h"
#import "DataRequest.h"
#import "Vehicle.h"

@interface SelectVehicleViewController ()
{
    NSArray *_vehicleArray;
    Vehicle *_vehicle;
}
@end

@implementation SelectVehicleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vehicleTable.tableFooterView=[[UIView alloc]init];
    [self setupData];

}

-(void)setupData
{
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            NSLog(@"%@",vehicleArray);
            _vehicleArray = [NSMutableArray arrayWithArray:vehicleArray];
            [CommonFunctionController hideAllHUD];
            [self.vehicleTable reloadData];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }

}

- (void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=@"车辆";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _vehicle=[_vehicleArray objectAtIndex:indexPath.row];
    self.dismiss(_vehicle);
    [self.navigationController popViewControllerAnimated:YES];
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
