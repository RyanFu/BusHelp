//
//  ViolationListViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ViolationListViewController.h"
#import "ViolationListTableViewCell.h"
#import "DataFetcher.h"
#import "CommonFunctionController.h"
#import "DataRequest.h"
#import "Violation.h"
#import "ViolationDetailViewController.h"

@interface ViolationListViewController ()
{
    NSArray *_vehicleArray;
    NSArray *_violationArray;
    Vehicle *_vehicle;
    Violation *_violation;
    int totalMoney;
    int totalScore;
    NSMutableArray *_finalArray;//有违章的车辆
    
    BOOL _isSearchViolation;
}
@end

@implementation ViolationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _finalArray=[[NSMutableArray alloc]init];
}

- (void)commonInit {
    [super commonInit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNotification:) name:searchNotificationKey object:nil];
}

- (void)searchNotification:(NSNotification *)notification {
    _isSearchViolation = YES;
}

- (void)setReferenceID:(NSString *)referenceID {
    if (![referenceID isEqualToString:_referenceID] && referenceID != nil) {
        _referenceID = referenceID;
        [self setupData];
    }
}

- (void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=@"违章";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    if ([UserSettingInfo fetchSplashHasShown]) {
        [self setupData];
    }

}

- (void)setupData {
    _vehicleArray = [DataFetcher fetchAllVehicle:YES];
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _vehicleArray = vehicleArray;
            NSLog(@"%@",_vehicleArray);
            [_finalArray removeAllObjects];
            for (int i=0; i<_vehicleArray.count; i++) {
                _vehicle=[_vehicleArray objectAtIndex:i];
                if (_vehicle.hasViolation.count>0) {
                    [_finalArray addObject:_vehicle];
                }
            }
            
            [self.VechicleListTable reloadData];
            [self setupEmptyMessage];
            [self reloadData:YES];
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}


- (void)reloadData:(BOOL)request {
    if (_vehicleArray.count > 0) {
            if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
            [DataRequest importAllViolationWithVehicleIDArray:[_vehicleArray valueForKeyPath:@"vehicleID"] success:^{
                [CommonFunctionController hideAllHUD];
                [self.VechicleListTable reloadData];
            } failure:^(NSString *message){
                [CommonFunctionController showHUDWithMessage:message success:NO];
            }];
        }
    }
    else {
        if (request) {
            [CommonFunctionController hideAllHUD];
        }
    }
}



- (void)setupEmptyMessage {
    BOOL hidden = YES;
    if ([CommonFunctionController checkValueValidate:_finalArray] == nil) {
        hidden = NO;
    }
    self.thumbimage.hidden=hidden;
    self.Label1.hidden=hidden;
    self.Label2.hidden=hidden;
    
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _finalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ViolationListTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"ViolationListTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    ViolationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    _vehicle=[_finalArray objectAtIndex:indexPath.section];
    cell.VehicleNumber.text=_vehicle.number;
    _violationArray=[_vehicle.hasViolation allObjects];
    totalMoney=0;
    totalScore=0;
    for (int i=0; i<_violationArray.count; i++) {
        _violation=[_violationArray objectAtIndex:i];
        totalMoney=totalMoney+_violation.money.intValue;
        totalScore=totalScore+_violation.score.intValue;
    }
    cell.money.text=[NSString stringWithFormat:@"-%i",totalMoney];
    cell.score.text=[NSString stringWithFormat:@"-%i",totalScore];
    cell.untreatedNumber.text=[NSString stringWithFormat:@"%i",_violationArray.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _vehicle=[_finalArray objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:@"ViolationListToDetail" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ViolationListToDetail"]) {
        ViolationDetailViewController *violationDetailVC=segue.destinationViewController;
        violationDetailVC.vehicle=_vehicle;
    }
}


@end
