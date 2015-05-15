//
//  ProvinceKeyboard.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ProvinceKeyboard.h"

static NSUInteger const singleRowCount = 9;
static CGFloat const buttonWidth = 26.0f;
static CGFloat const buttonHeight = 39.0f;
static CGFloat const toolbarHeight = 44.0f;

@interface ProvinceKeyboard ()

@property (copy, nonatomic) void (^provinceButtonPressedBlock)(NSString *name);

@end

@implementation ProvinceKeyboard

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)commonInit {
    self.backgroundColor = [UIColor colorWithRed:195.0f / 255.0f green:196.0f / 255.0f blue:202.0f / 255.0f alpha:1.0f];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.width, toolbarHeight)];
    [self addSubview:toolbar];
    toolbar.tintColor = [UIColor darkTextColor];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *leftSaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightSaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSaceButtonItem.width = 8.0f;
    NSArray *toolbarItems = @[leftSaceButtonItem, doneButtonItem, rightSaceButtonItem];
    toolbar.items = toolbarItems;
    
    NSArray *provinceArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ShortProvince" ofType:@"plist"]];
    CGFloat space = ([UIApplication sharedApplication].keyWindow.width - singleRowCount * buttonWidth) / (singleRowCount + 1);
    CGFloat top = space + toolbarHeight;
    CGFloat left = space;
    CGFloat margin = 2 * space;
    for (NSInteger i = 0; i < provinceArray.count; i++) {
        UIButton *provinceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        provinceButton.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
        [provinceButton setTitle:provinceArray[i] forState:UIControlStateNormal];
        [provinceButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [provinceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [provinceButton setBackgroundImage:[UIImage imageNamed:@"province-button"] forState:UIControlStateNormal];
        [provinceButton addTarget:self action:@selector(provinceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:provinceButton];
        left += buttonWidth + space;
        if ((i + 1) % singleRowCount == 0) {
            top += buttonHeight + margin;
            left = space;
        }
    }
    self.bounds = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.width, top + buttonHeight + margin);
}

- (void)provinceButtonPressed:(UIButton *)sender {
    if (self.provinceButtonPressedBlock != nil) {
        self.provinceButtonPressedBlock(sender.titleLabel.text);
    }
    [ProvinceKeyboard hide];
}

- (void)done:(UIBarButtonItem *)barButtonItem {
    [ProvinceKeyboard hide];
}

+ (void)showWithBlock:(void(^)(NSString *name))block {
    ProvinceKeyboard *provinceKeyboard = (ProvinceKeyboard *)[[UIApplication sharedApplication].keyWindow viewWithTag:10000];
    if (provinceKeyboard == nil) {
        provinceKeyboard = [[ProvinceKeyboard alloc] init];
        [provinceKeyboard setProvinceButtonPressedBlock:block];
        provinceKeyboard.tag = 10000;
        provinceKeyboard.center = CGPointMake(provinceKeyboard.width / 2.0f, [UIApplication sharedApplication].keyWindow.height + provinceKeyboard.height / 2.0f);
        [[UIApplication sharedApplication].keyWindow addSubview:provinceKeyboard];
        [UIView animateWithDuration:0.25f animations:^{
            provinceKeyboard.center = CGPointMake(provinceKeyboard.width / 2.0f, [UIApplication sharedApplication].keyWindow.height - provinceKeyboard.height / 2.0f);
        }];
    }
}

+ (void)hide {
    __block ProvinceKeyboard *provinceKeyboard = (ProvinceKeyboard *)[[UIApplication sharedApplication].keyWindow viewWithTag:10000];
    [UIView animateWithDuration:0.25f animations:^{
        provinceKeyboard.center = CGPointMake(provinceKeyboard.width / 2.0f, [UIApplication sharedApplication].keyWindow.height + provinceKeyboard.height / 2.0f);
    } completion:^(BOOL finished) {
        [provinceKeyboard removeFromSuperview];
        provinceKeyboard = nil;
    }];
}

@end
