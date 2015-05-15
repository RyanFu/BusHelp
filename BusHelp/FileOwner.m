//
//  FileOwner.m
//  IToyEditor
//
//  Created by Tony Zeng on 15/1/21.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "FileOwner.h"

@implementation FileOwner

+ (id)viewFromNibNamed:(NSString *)nibName {
    FileOwner *fileOwner = [[FileOwner alloc] init];
    [[NSBundle mainBundle] loadNibNamed:nibName owner:fileOwner options:nil];
    return fileOwner.view;
}

@end
