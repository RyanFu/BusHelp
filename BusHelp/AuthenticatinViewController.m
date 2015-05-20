//
//  AuthenticatinViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/19.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "AuthenticatinViewController.h"
#import "ImageCache.h"

@interface AuthenticatinViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageVerticalConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel3;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel4;

@end

@implementation AuthenticatinViewController
@synthesize vehicle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGeture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImage:)];
    tapGeture.numberOfTouchesRequired=1;
    tapGeture.numberOfTapsRequired=1;
    [self.MyImage addGestureRecognizer:tapGeture];
    
    self.MyImage.image=[ImageCache cacheForKey:vehicle.vehicleID];
    
//    self.ImageVerticalConstraint.constant=20;
//    self.lineLabel2.hidden=YES;
//    self.lineLabel3.hidden=YES;
//    self.lineLabel4.hidden=YES;
    
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
        UIImage *scaleImage = [CommonFunctionController imageCompressForSize:[info objectForKey:UIImagePickerControllerOriginalImage] targetSize:CGSizeMake(800, 600)];
        [ImageCache storeCache:scaleImage forKey:vehicle.vehicleID];
        self.MyImage.image=scaleImage;

    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:22.0f/255.0f green:164.0f/255.0f blue:220.0f/255.0f alpha:1.0f]];


    }];
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
