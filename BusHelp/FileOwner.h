//
//  FileOwner.h
//  IToyEditor
//
//  Created by Tony Zeng on 15/1/21.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOwner : NSObject

@property (weak, nonatomic) IBOutlet UIView *view;

+ (id)viewFromNibNamed:(NSString *)nibName;

@end
