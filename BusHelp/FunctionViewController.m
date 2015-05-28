//
//  FunctionViewController.m
//  BusHelp
//
//  Created by Paul on 15/4/29.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "FunctionViewController.h"
#import "FunctionTableViewCell.h"
#import "DataRequest.h"
#import "StationMapViewController.h"

@interface FunctionViewController ()
{
    NSArray *funclist;
    StationMapViewController *stationMapVC;
}
@end

@implementation FunctionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    funclist=[NSArray arrayWithObjects:@"违章",@"油耗",@"任务",@"里程",@"实时监测",@"充电站", nil];
    self.FunctionTable.tableFooterView=[[UIView alloc]init];
    
    stationMapVC=[[StationMapViewController alloc]initWithNibName:@"StationMapViewController" bundle:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
    switch (indexPath.row) {
        case 0:
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-violation"];
            break;
        case 1:
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-oilmanager"];
            break;
        case 2:
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-task"];
            break;
        case 3:
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-mileage"];
            break;
        case 4:
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-detection"];
            break;
        case 5:
            cell.FunctionImage.image=[UIImage imageNamed:@"cell-detection"];
            break;

        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"FunctionToViolation" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"FunctionToOilManager" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"FunctionToTaskManager" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"FunctionToMileage" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"FunctionToVehicleDetail" sender:self];
            break;
        case 5:
            [self.navigationController pushViewController:stationMapVC animated:YES];
            
            break;
        default:
            break;
    }
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
