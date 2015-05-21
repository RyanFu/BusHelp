//
//  AuthenticatinViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/19.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "ImageCache.h"
#import "DataRequest.h"
#import "UIImageView+WebCache.h"

@interface AuthenticationViewController ()
{
    UIImage *scaleImage;
    NSArray *myimageArray;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageVerticalConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel3;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel4;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitButtonPressed:(id)sender;

@end

@implementation AuthenticationViewController
@synthesize vehicle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGeture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImage:)];
    tapGeture.numberOfTouchesRequired=1;
    tapGeture.numberOfTapsRequired=1;
    [self.MyImage addGestureRecognizer:tapGeture];
    
    if([ImageCache hasCacheForKey:vehicle.vehicleID])
    {
        self.MyImage.image=[ImageCache cacheForKey:vehicle.vehicleID];
    }else
    {
        if ([CommonFunctionController checkNetworkWithNotify:NO]) {
            [CommonFunctionController showAnimateMessageHUD];
            [DataRequest fetchVehicleDrivingLicense:vehicle.vehicleID success:^(id data){
                NSArray *array=[NSArray arrayWithArray:data];
                if (array.lastObject) {
                    [self.MyImage sd_setImageWithURL:[[data objectAtIndex:0] objectForKey:@"attach_url"]];
                }
            [CommonFunctionController hideAllHUD];
            }failure:^(NSString *message){
            }];
        }

    }
    
    if ([vehicle.identify_status isEqualToString:@"2001"]) {
        self.ImageVerticalConstraint.constant=10;
        self.lineLabel2.hidden=YES;
        self.lineLabel3.hidden=YES;
        self.lineLabel4.hidden=YES;
        self.lineLabel1.text=@"正在进行认证审核，一般会在3个工作日内审核完毕，审核结果将以推送方式告知。";
        [self.commitButton setTitle:@"重新提交" forState:UIControlStateNormal];
    }

    
}

- (void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=@"认证";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addImage:(UITapGestureRecognizer *)sender
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照", nil];
    [sheet showInView:self.view];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    @autoreleasepool {
        scaleImage = [CommonFunctionController imageCompressForSize:[info objectForKey:UIImagePickerControllerOriginalImage] targetSize:CGSizeMake(800, 600)];
//        [ImageCache storeCache:scaleImage forKey:vehicle.vehicleID];
        self.MyImage.image=scaleImage;

    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:22.0f/255.0f green:164.0f/255.0f blue:220.0f/255.0f alpha:1.0f]];


    }];
}

- (IBAction)commitButtonPressed:(id)sender {
    myimageArray=[NSArray arrayWithObject:self.MyImage.image];
//    [DataRequest saveVehicleDrivingLicense:vehicle.vehicleID imageArray:myimageArray success:^(id data){
//        NSLog(@"success");
//    }failure:^(NSString *message){
//        
//    }];
    
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
