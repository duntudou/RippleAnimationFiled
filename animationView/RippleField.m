//
//  RippleField.m
//  弹性动画框
//
//  Created by liudianling on 15/10/13.
//  Copyright © 2015年 zhaohengzhi. All rights reserved.
//

#import "RippleField.h"
#import "RippleView.h"

@interface RippleField ()

@property(nonatomic,weak)RippleView *rippleView;

@end
@implementation RippleField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpConentView];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpConentView];
    }
    return self;
}

-(void)setUpConentView{

    self.clipsToBounds=NO;
    RippleView *rippleView=[[RippleView alloc] initWithFrame:self.bounds];
    rippleView.rippleValue=15;
    rippleView.backgroundColor=self.backgroundColor;
    rippleView.userInteractionEnabled=NO;
    _rippleView=rippleView;
    [self addSubview:rippleView];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [_rippleView touchesBegan:touches withEvent:event];
}


-(CGRect)textRectForBounds:(CGRect)bounds{

    return   CGRectInset(bounds, 5, 0);
}

-(CGRect)editingRectForBounds:(CGRect)bounds{

    return   CGRectInset(bounds, 5, 0);
}

@end
