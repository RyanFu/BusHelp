//
//  StationAnnotationView.m
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import "StationAnnotationView.h"

#define arrow_height 15

@implementation StationAnnotationView : MKAnnotationView

@synthesize contentView;

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -120);
        self.frame = CGRectMake(0, 0, 280, 180 + arrow_height);
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - arrow_height)];
        _contentView.backgroundColor   = [UIColor clearColor];
        [self addSubview:_contentView];
        self.contentView = _contentView;
    }
    return self;
}

- (void)dealloc
{
    self.contentView = nil;
}

-(void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
    //CGContextSetLineWidth(context, 1.0);
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //[self getDrawPath:context];
    //CGContextStrokePath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 0.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    //midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect) - arrow_height;
    CGContextMoveToPoint(context, midx + arrow_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy + arrow_height);
    CGContextAddLineToPoint(context,midx - arrow_height, maxy);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    //self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

@end
