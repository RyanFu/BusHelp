//
//  CustomGasStationViewController.m
//  BusHelp
//
//  Created by Tony Zeng on 15/2/27.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "CustomGasStationViewController.h"
#import "CustomGasStationView.h"
#import "DataFetcher.h"
#import "HelpView.h"

@interface CustomGasStationViewController () <UITableViewDataSource, UITableViewDelegate> {
    CustomGasStationView *_stationView;
    NSMutableArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *stationTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;

- (IBAction)addBarButtonItemPressed:(UIBarButtonItem *)sender;

@end

@implementation CustomGasStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _stationView = nil;
    _dataArray = nil;
    self.name = nil;
    self.stationNameChangedBlock = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)commonInit {
    [super commonInit];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.stationTableView setTableFooterView:view];
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = self.isStation ? @"选择加油站" : @"选择油品";
    self.titleBarButtonItem.title = self.isStation ? @"自定义加油站" : @"自定义油品";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self setupData];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    if (self.stationNameChangedBlock != nil) {
        self.stationNameChangedBlock(self.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData {
    if (self.isStation) {
        [HelpView showWithImageArray:@[@"help-6"]];
        StationItem *stationItem = [[StationItem alloc] init];
        stationItem.name = self.name;
        [DataFetcher addStationByStationItem:stationItem completion:^{
            _dataArray = [NSMutableArray arrayWithArray:[DataFetcher fetchAllStation]];
            [self.stationTableView reloadData];
        }];
    }
    else {
        OilTypeItem *oilTypeItem = [[OilTypeItem alloc] init];
        oilTypeItem.name = self.name;
        [DataFetcher addOilTypeByOilTypeItem:oilTypeItem completion:^{
            _dataArray = [NSMutableArray arrayWithArray:[DataFetcher fetchAllOilType]];
            [self.stationTableView reloadData];
        }];
    }
}

- (IBAction)addBarButtonItemPressed:(UIBarButtonItem *)sender {
    if (_stationView != nil) {
        [_stationView removeFromSuperview];
        _stationView = nil;
    }
    _stationView = [CustomGasStationView loadFromNib];
    _stationView.type = self.isStation ? ViewTypeStation : ViewTypeOil;
    __weak CustomGasStationViewController *weakSelf = self;
    [_stationView setConfirmButtonPressedBlock:^(NSString *name, ViewType type) {
        if (type == ViewTypeStation) {
            StationItem *stationItem = [[StationItem alloc] init];
            stationItem.name = name;
            weakSelf.name = name;
            [DataFetcher addStationByStationItem:stationItem completion:^{
                [weakSelf setupData];
            }];
        }
        else {
            OilTypeItem *oilTypeItem = [[OilTypeItem alloc] init];
            oilTypeItem.name = name;
            weakSelf.name = name;
            [DataFetcher addOilTypeByOilTypeItem:oilTypeItem completion:^{
                [weakSelf setupData];
            }];
        }
    }];
    [_stationView showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma - UITableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"stationIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.isStation) {
        Station *station = [_dataArray objectAtIndex:indexPath.row];
        if ([station.name isEqualToString:self.name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = [station name];
    }
    else {
        OilType *oilType = [_dataArray objectAtIndex:indexPath.row];
        if ([oilType.name isEqualToString:self.name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = [oilType name];
    }
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.isStation) {
            Station *station = [_dataArray objectAtIndex:indexPath.row];
            [DataFetcher removeStationByStation:station completion:^{
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    self.name = @"";
                }
                if (self.stationNameChangedBlock != nil) {
                    self.stationNameChangedBlock(self.name);
                }
                [_dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        else {
            OilType *oilType = [_dataArray objectAtIndex:indexPath.row];
            [DataFetcher removeOilTypeByOilType:oilType completion:^{
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    self.name = @"";
                }
                if (self.stationNameChangedBlock != nil) {
                    self.stationNameChangedBlock(self.name);
                }
                [_dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isStation) {
        Station *station = [_dataArray objectAtIndex:indexPath.row];
        self.name = station.name;
    }
    else {
        OilType *oilType = [_dataArray objectAtIndex:indexPath.row];
        self.name = oilType.name;
    }
    if (self.stationNameChangedBlock != nil) {
        self.stationNameChangedBlock(self.name);
    }
    [tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
