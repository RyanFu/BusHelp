//
//  EditOilViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/24.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "EditOilViewController.h"
#import "RoundCornerButton.h"
#import "NSDate+custom.h"
#import "NSString+custom.h"
#import <SwipeView/SwipeView.h>
#import "AttachmentView.h"
#import <ImageIO/ImageIO.h>
#import "ImageCache.h"
#import "CustomGasStationViewController.h"
#import "FSImageViewerViewController.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"

@interface EditOilViewController () <UITextFieldDelegate, SwipeViewDelegate, SwipeViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    NSMutableArray *_addImageArray;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *mileageTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *timeDatePicker;
@property (weak, nonatomic) IBOutlet UIView *timeDatePickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewBottom;
@property (weak, nonatomic) IBOutlet SwipeView *attachmentSwipeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipeViewTopConstraint;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilTypeLabel;


- (IBAction)timeViewTapped:(UITapGestureRecognizer *)gesture;
- (IBAction)stationViewTapped:(UITapGestureRecognizer *)gesture;
- (IBAction)oilTypeViewTapped:(UITapGestureRecognizer *)gesture;
- (IBAction)doneBarButtonPressed:(id)sender;
- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;
- (IBAction)cameraButtonPressed:(UIButton *)sender;

@end

@implementation EditOilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _addImageArray = nil;
    self.imageArray = nil;
    self.navigationTitle = nil;
    self.vehicleID = nil;
    self.oilItem = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.timeLabel.text = [[NSDate date] dateToStringWithFormatter:@"yyyy-MM-dd"];
    self.attachmentSwipeView.pagingEnabled = YES;
    [self setupData];
}

- (void)setImageArray:(NSMutableArray *)imageArray {
    if (![imageArray isEqual:_imageArray]) {
        _imageArray = imageArray;
        [self shouldShowSwipeView];
    }
}

- (void)shouldShowSwipeView {
    if ([CommonFunctionController checkValueValidate:self.imageArray] == nil) {
        self.swipeViewTopConstraint.constant = 0;
        self.swipeViewHeightConstraint.constant = 0;
    }
    else {
        self.swipeViewTopConstraint.constant = 15.0f;
        self.swipeViewHeightConstraint.constant = 88.0f;
    }
    [self.attachmentSwipeView reloadData];
}

- (void)setupData {
    if (self.oilItem != nil) {
        self.timeLabel.text = self.oilItem.time;
        self.timeDatePicker.date = [self.oilItem.time stringToDateWithFormatter:@"yyyy-MM-dd"];
        self.numberTextField.text = [NSString stringWithFormat:@"%.2f", [self.oilItem.number floatValue]];
        self.moneyTextField.text = [NSString stringWithFormat:@"%.2f", [self.oilItem.money floatValue]];
        self.mileageTextField.text = [NSString stringWithFormat:@"%ld", (long)[self.oilItem.mileage integerValue]];
        self.priceTextField.text = [NSString stringWithFormat:@"%.2f", [self.oilItem.price floatValue]];
        self.imageArray = [NSMutableArray arrayWithArray:self.oilItem.attachmentList];
        self.oilTypeLabel.text = self.oilItem.typeName;
        self.stationLabel.text = self.oilItem.stationName;
    }
    else {
        self.stationLabel.text = [(Station *)[[DataFetcher fetchAllStation] firstObject] name];
        self.oilTypeLabel.text = [(OilType *)[[DataFetcher fetchAllOilType] firstObject] name];
    }
    if ([CommonFunctionController checkValueValidate:self.imageArray] == nil) {
        self.imageArray = [NSMutableArray arrayWithCapacity:2];
    }
    _addImageArray = [NSMutableArray arrayWithCapacity:2];
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = self.navigationTitle;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBarButtonItemPressed:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)saveOilItemWithCompletion:(void(^)())completion {
    BOOL update = NO;
     OilItem *oilItem = nil;
    if (self.oilItem != nil) {
        update = YES;
        oilItem = self.oilItem;
    }
    else {
        oilItem = [[OilItem alloc] init];
        oilItem.oilID = [[NSUUID UUID] UUIDString];
    }
    CGFloat avgNumber = [self.numberTextField.text floatValue] / [self.mileageTextField.text floatValue] * 100;
    oilItem.avgNumber = [NSNumber numberWithFloat:[[NSString stringWithFormat:@"%.2f", avgNumber] floatValue]];
    oilItem.mileage = [NSNumber numberWithFloat:[self.mileageTextField.text floatValue]];
    if (oilItem.mileage == nil) {
        oilItem.mileage = @0;
    }
    oilItem.money = [NSNumber numberWithFloat:[self.moneyTextField.text floatValue]];
    oilItem.number = [NSNumber numberWithFloat:[self.numberTextField.text floatValue]];
    oilItem.price = [NSNumber numberWithFloat:[self.priceTextField.text floatValue]];
    oilItem.time = [self.timeDatePicker.date dateToStringWithFormatter:@"yyyy-MM-dd"];
    oilItem.typeName = self.oilTypeLabel.text;
    if (oilItem.typeName == nil) {
        oilItem.typeName = @"";
    }
    oilItem.stationName = self.stationLabel.text;
    if (oilItem.stationName == nil) {
        oilItem.stationName = @"";
    }
    oilItem.vehicleID = self.vehicleID;
    oilItem.isSubmit = [NSNumber numberWithBool:NO];
    if (oilItem.dataType == nil) {
        oilItem.dataType = [NSNumber numberWithInteger:OilDataTypeAddUncommitted];
    }
    else {
        if ([oilItem.dataType integerValue] == OilDataTypeCommitted) {
            oilItem.dataType = [NSNumber numberWithInteger:OilDataTypeModifyUncommitted];
        }
    }
    NSArray *originalImageArray = oilItem.attachmentList;
    oilItem.attachmentList = self.imageArray;
//    if ([oilItem.mileage integerValue] == 0) {
//        [CommonFunctionController showHUDWithMessage:@"当前里程不能为零!" success:NO];
//    }
//    if ([CommonFunctionController checkValueValidate:oilItem.typeName] == nil) {
//        [CommonFunctionController showHUDWithMessage:@"油品不能为空!" success:NO];
//    }
    if ([oilItem.price floatValue] == 0) {
        [CommonFunctionController showHUDWithMessage:@"单价不能为零!" success:NO];
    }
    else if ([oilItem.money floatValue] == 0) {
        [CommonFunctionController showHUDWithMessage:@"金额不能为零!" success:NO];
    }
    else if ([oilItem.number floatValue] == 0) {
        [CommonFunctionController showHUDWithMessage:@"加油量不能为零!" success:NO];
    }
//    else if ([CommonFunctionController checkValueValidate:oilItem.stationName] == nil) {
//        [CommonFunctionController showHUDWithMessage:@"加油站不能为空!" success:NO];
//    }
    else {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest saveOilWithOilItem:oilItem update:update success:^{
            [_addImageArray removeAllObjects];
            for (NSString *url in originalImageArray) {
                if (![self.imageArray containsObject:url]) {
                    [_addImageArray addObject:url];
                }
            }
            [self clearImageCache];
            NSString *message = @"添加成功！";
            if (update) {
                message = @"更新成功！";
            }
            [CommonFunctionController showHUDWithMessage:message success:YES];
            completion();
        } failure:^(NSString *message) {
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (void)clearImageCache {
    [ImageCache clearCacheWithKeyArray:_addImageArray];
    [self.attachmentSwipeView removeFromSuperview];
    self.attachmentSwipeView = nil;
    _addImageArray = nil;
    self.imageArray = nil;
    self.navigationTitle = nil;
    self.vehicleID = nil;
    self.oilItem = nil;
    [CommonFunctionController removeAllSubviewByView:self.view];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self clearImageCache];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self showDatePickerView:NO];
    [CommonFunctionController resignFirstResponderByView:self.view];
    __weak EditOilViewController *weakSelf = self;
    [self saveOilItemWithCompletion:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)timeViewTapped:(UITapGestureRecognizer *)gesture {
    [CommonFunctionController resignFirstResponderByView:self.view];
    self.timeDatePicker.maximumDate = [NSDate date];
    [self showDatePickerView:YES];
}

- (IBAction)stationViewTapped:(UITapGestureRecognizer *)gesture {
    CustomGasStationViewController *customStationViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CustomGasStationViewController class])];
    customStationViewController.name = self.stationLabel.text;
    customStationViewController.isStation = YES;
    [customStationViewController setStationNameChangedBlock:^(NSString *name) {
        self.stationLabel.text = name;
    }];
    [self.navigationController pushViewController:customStationViewController animated:YES];
}

- (IBAction)oilTypeViewTapped:(UITapGestureRecognizer *)gesture {
    CustomGasStationViewController *customStationViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CustomGasStationViewController class])];
    customStationViewController.name = self.oilTypeLabel.text;
    customStationViewController.isStation = NO;
    [customStationViewController setStationNameChangedBlock:^(NSString *name) {
        self.oilTypeLabel.text = name;
    }];
    [self.navigationController pushViewController:customStationViewController animated:YES];
}

- (IBAction)doneBarButtonPressed:(id)sender {
    [self showDatePickerView:NO];
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    self.timeLabel.text = [sender.date dateToStringWithFormatter:@"yyyy-MM-dd"];
}

- (IBAction)cameraButtonPressed:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", @"拍照", nil];
    [actionSheet showInView:self.view];
}

- (void)showDatePickerView:(BOOL)show {
    self.pickerViewBottom.constant = show ? 0 : -self.timeDatePickerView.height;
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self showDatePickerView:NO];
    
    CGFloat price = [self.priceTextField.text floatValue];
    CGFloat money = [self.moneyTextField.text floatValue];
    CGFloat number = [self.numberTextField.text floatValue];
    
    if ([textField isEqual:self.priceTextField]) {
        if (number > 0 && money > 0) {
            textField.text = [NSString stringWithFormat:@"%.2f", money / number];
        }
    }
    else if ([textField isEqual:self.moneyTextField]) {
        if (price > 0 && number > 0) {
            textField.text = [NSString stringWithFormat:@"%.2f", price * number];
        }
    }
    else if ([textField isEqual:self.numberTextField]) {
        if (price > 0 && money > 0) {
            textField.text = [NSString stringWithFormat:@"%.2f", money / price];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGFloat value = [textField.text floatValue];
    textField.text = [NSString stringWithFormat:@"%.2f", value];
    
    CGFloat price = [self.priceTextField.text floatValue];
    CGFloat money = [self.moneyTextField.text floatValue];
    
    if (price > 0 && money > 0) {
        self.numberTextField.text = [NSString stringWithFormat:@"%.2f", money / price];
    }
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
