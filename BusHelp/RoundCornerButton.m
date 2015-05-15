//
//  RoundCornerButton.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "RoundCornerButton.h"

@interface RoundCornerButton () {
    UIColor *_normalColor;
}

@end

@implementation RoundCornerButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    _normalColor = self.backgroundColor;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self setTitleColor:self.titleLabel.textColor forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (void)setButtonSelected:(BOOL)buttonSelected {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    _buttonSelected = buttonSelected;
    self.selected = buttonSelected;
    [self setBackgroundColor:_buttonSelected ? _normalColor : [UIColor whiteColor]];
    self.layer.borderWidth = _buttonSelected ? 0.0f : 1.0f;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.8]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:_normalColor];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:_normalColor];
}

@end
