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
#import "DataFetcher.h"
#import "AttachmentView.h"
#import <ImageIO/ImageIO.h>
#import "ImageCache.h"
#import "FSImageViewerViewController.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"

#define PICKERVIEW_HEIGHT 206
#define TOP_HEIGHT 64

@interface AddTaskViewController ()<SwipeViewDelegate, SwipeViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSMutableString *Name_multistring;
    NSMutableString *Userid_multistring;
    NSString *Org_id;
    NSMutableString *vehicleids_Mutistring;
    NSMutableString *vehicleNumbers_Mutistring;
    MyDataPickerView *pickerview;
    NSString *vehicles_string;//final
    NSString *usersid_string;//final
    Org *_org;
    NSMutableArray *_addImageArray;

}
@end

@implementation AddTaskViewController

-(void)viewWillAppear:(BOOL)animated
{
    if ([DataFetcher fetchAllOrg].count) {
        _org=[[DataFetcher fetchAllOrg] firstObject];
        Org_id=_org.orgID;
        [self setupNavigationBar];
    }else
    {
        [self setupOrgWithRequest:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    vehicleids_Mutistring=[[NSMutableString alloc]init];
    vehicleNumbers_Mutistring=[[NSMutableString alloc]init];
    vehicles_string=@"";
    usersid_string=@"";
    Name_multistring=[[NSMutableString alloc]init];
    Userid_multistring=[[NSMutableString alloc]init];
    Org_id=@"";

    
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

- (void)setImageArray:(NSMutableArray *)imageArray {
    if (![imageArray isEqual:_imageArray]) {
        _imageArray = imageArray;
        [self shouldShowSwipeView];
    }
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


-(void)commonInit
{
    [super commonInit];
    if ([CommonFunctionController checkValueValidate:self.imageArray] == nil) {
        self.imageArray = [NSMutableArray arrayWithCapacity:2];
    }
    _addImageArray = [NSMutableArray arrayWithCapacity:2];
}

-(void)saveTask
{
    [self.taskTitle resignFirstResponder];
    [self.taskContent resignFirstResponder];
    if ([CommonFunctionController checkValueValidate:self.taskTitle.text]&&[CommonFunctionController checkValueValidate:self.managerLabel.text]) {
        if (![self compareDate:self.beginTimeLabel.text endDate:self.endTimeLabel.text]) {
            [CommonFunctionController showHUDWithMessage:@"请检查您的日期" detail:nil];
        }else
        {
            [CommonFunctionController showAnimateHUDWithMessage:@"提交中.."];
            [DataRequest saveNewTask:@"" org_id:Org_id task_title:self.taskTitle.text task_content:self.taskContent.text task_manager:usersid_string task_begin_time:self.beginTimeLabel.text task_end_time:self.endTimeLabel.text vehicle_ids:vehicles_string imageArray:self.imageArray success:^(id data){
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
    [self hidePickerView:YES];
    if(textView==self.taskTitle)
    {
        self.placeholder_title.hidden = YES;
        
    }else if (textView==self.taskContent)
    {
        self.placeholder_content.hidden = YES;
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (textView==self.taskTitle) {
//        if (![text isEqualToString:@""])
//        {
//            self.placeholder_title.hidden = YES;
//        }
//        
//        else if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
//        {
//            self.placeholder_title.hidden = NO;
//        }
//    }else if(textView==self.taskContent)
//    {
//        if (![text isEqualToString:@""])
//        {
//            self.placeholder_content.hidden = YES;
//        }
//        
//        else if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
//        {
//            self.placeholder_content.hidden = NO;
//        }
//
//    }
//        return YES;
//}

- (IBAction)managerViewTappedGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"负责人");
    [self hidePickerView:YES];
    [Name_multistring setString:@""];
    [Userid_multistring setString:@""];
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

- (IBAction)cameraButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", @"拍照", nil];
    [actionSheet showInView:self.view];

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
            for (int i=0; i<select.count; i++) {
                NotificationItem *item=[select objectAtIndex:i];
                [Name_multistring appendString:[NSString stringWithFormat:@"%@,",item.username]];
                [Userid_multistring appendString:[NSString stringWithFormat:@"%@,",item.userid]];
            }
            if (Name_multistring.length) {
                self.managerLabel.text=[Name_multistring substringWithRange:NSMakeRange(0,[Name_multistring length]-1)];
            }
            if (Userid_multistring.length) {
                usersid_string=[Userid_multistring substringWithRange:NSMakeRange(0, [Userid_multistring length]-1)];

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

-(void)setupOrgWithRequest:(BOOL)request {
    [CommonFunctionController showAnimateMessageHUD];
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _org = [orgArray firstObject];
            if (_org) {
                Org_id=_org.orgID;
                [self setupNavigationBar];
                [CommonFunctionController hideAllHUD];
            }else
            {
                [CommonFunctionController showHUDWithMessage:@"请先加入组织" detail:nil];
            }
            
        } failure:^(NSString *message){
            
        }];
    }
    else {
        [CommonFunctionController showHUDWithMessage:@"网络已断开" detail:nil];
        
    }
}

- (void)shouldShowSwipeView {
    if ([CommonFunctionController checkValueValidate:self.imageArray] == nil) {
        self.LayoutConstraintSwipeHeight.constant = 0;
        self.LayoutConstrainCamerTopToSwipeBottom.constant = 0;
    }
    else {
        self.LayoutConstrainCamerTopToSwipeBottom.constant = 8.0f;
        self.LayoutConstraintSwipeHeight.constant = 70.0f;
    }
    [self.attachmentSwipeView reloadData];
}


#pragma - SwipeView datasource and delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return _imageArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        @autoreleasepool {
            view = [AttachmentView loadFromNib];
        }
    }
    
    [(AttachmentView *)view setImageUrl:[_imageArray objectAtIndex:index]];
    [(AttachmentView *)view setDeleteButtonPressedBlock:^(AttachmentView *attachmentView) {
        [self.imageArray removeObject:attachmentView.imageUrl];
        if ([_addImageArray containsObject:attachmentView.imageUrl]) {
            [ImageCache clearCacheWithKeyArray:@[attachmentView.imageUrl]];
            [_addImageArray removeObject:attachmentView.imageUrl];
        }
        [self shouldShowSwipeView];
    }];
    [(AttachmentView *)view setImageViewTapBlock:^(AttachmentView *attachmentView) {
        NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:_imageArray.count];
        for (NSString *url in _imageArray) {
            FSBasicImage *photo = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:url] name:nil];
            [photoArray addObject:photo];
        }
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:photoArray];
        FSImageViewerViewController *photoController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
        photoController.sharingDisabled = YES;
        photoController.backgroundColorVisible = [UIColor whiteColor];
        photoController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController pushViewController:photoController animated:YES];
        [photoController moveToImageAtIndex:index animated:YES];
    }];
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return CGSizeMake(100.0f, 88.0f);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    @autoreleasepool {
        UIImage *scaleImage = [CommonFunctionController imageCompressForSize:[info objectForKey:UIImagePickerControllerOriginalImage] targetSize:CGSizeMake(600, 800)];
        NSString *key = [[NSUUID UUID] UUIDString];
        [ImageCache storeCache:scaleImage forKey:key];
        [self.imageArray addObject:key];
        [_addImageArray addObject:key];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:22.0f/255.0f green:164.0f/255.0f blue:220.0f/255.0f alpha:1.0f]];
        [self shouldShowSwipeView];
    }];
}

#pragma - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate =self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else{
            [CommonFunctionController showHUDWithMessage:@"你没有摄像头！" success:NO];
        }
    }
}


@end
