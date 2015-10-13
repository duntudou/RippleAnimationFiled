//
//  animationView.m
//  弹性动画框
//
//  Created by liudianling on 15/10/13.
//  Copyright © 2015年 zhaohengzhi. All rights reserved.
//

#import "RippleView.h"

@interface RippleView ()

@property(nonatomic,weak)CAShapeLayer *shapeLayer;
@property(nonatomic,weak)UIView *topControlView;
@property(nonatomic,weak)UIView *leftControlView;
@property(nonatomic,weak)UIView *bottomControlView;
@property(nonatomic,weak)UIView *rightControlView;

@property(nonatomic,strong)NSArray *controlViewArray;

@property(nonatomic,strong)CADisplayLink *displayLink;
@property(nonatomic,assign)BOOL animation;
@end
@implementation RippleView


-(CADisplayLink *)displayLink{

    if (_displayLink==nil) {
        _displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(changeControlPoint)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
       
    }
    return _displayLink;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpShapelayer];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds=NO;
        _animation=NO;
        [self setUpShapelayer];
    }
    return self;
}

-(void)changeControlPoint{

    _shapeLayer.path=[self bezierPathForControlPoints];
}
-(void)setUpShapelayer{
    

    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    _shapeLayer=shapeLayer;
    _rippleValue=10;
    self.backgroundColor=[UIColor clearColor];
    UIBezierPath *path=[UIBezierPath bezierPathWithRect:self.bounds];
    shapeLayer.path=path.CGPath;
    [self.layer addSublayer:shapeLayer];
    
     [self setUpControlView];
}

-(void)setUpControlView{

    UIView *topControlView=[[UIView alloc] init];
    topControlView.backgroundColor=[UIColor blueColor];
    _topControlView=topControlView;
    
    UIView *leftControlView=[[UIView alloc] init];
    leftControlView.backgroundColor=[UIColor yellowColor];
    _leftControlView=leftControlView;

    UIView *bottomControlView=[[UIView alloc] init];
    bottomControlView.backgroundColor=[UIColor greenColor];
    _bottomControlView=bottomControlView;
    
    UIView *rightControlView=[[UIView alloc] init];
    rightControlView.backgroundColor=[UIColor blackColor];
    _rightControlView=rightControlView;
    
    _controlViewArray=@[topControlView,leftControlView,bottomControlView,rightControlView];
    
    [self configureControlView];
    [self configerControlPoints];
}

-(void)configureControlView{

    for (UIView *controlView in _controlViewArray) {
        controlView.bounds=CGRectMake(0, 0, 5, 5);
        controlView.backgroundColor=[UIColor clearColor];
        [self addSubview:controlView];
    }
}

//设置controlView的位置

-(void)configerControlPoints{

    _topControlView.center=CGPointMake(CGRectGetMidX(self.bounds), 0);
    _leftControlView.center=CGPointMake(0, CGRectGetMidY(self.bounds));
    _bottomControlView.center=CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    _rightControlView.center=CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
}


-(CGPathRef)bezierPathForControlPoints{

    UIBezierPath *path=[UIBezierPath bezierPath];
    
    CGPoint top =((CALayer *)_topControlView.layer.presentationLayer).position;
    CGPoint left = ((CALayer *)_leftControlView.layer.presentationLayer).position;
    CGPoint bottom = ((CALayer *)_bottomControlView.layer.presentationLayer).position;
    CGPoint right =((CALayer *)_rightControlView.layer.presentationLayer).position;

    CGFloat width=self.bounds.size.width;
    CGFloat height=self.bounds.size.height;

    [path moveToPoint:CGPointMake(0, 0)];
    [path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:top];
    [path addQuadCurveToPoint:CGPointMake(width, height) controlPoint:right];
    [path addQuadCurveToPoint:CGPointMake(0, height) controlPoint:bottom];
    [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:left];


    return path.CGPath;
}


-(void)animationtoToLayer{

    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1.9 initialSpringVelocity:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        _animation=YES;
        CGPoint topCenter=_topControlView.center;
        topCenter.y-=_rippleValue;
        _topControlView.center=topCenter;
        
        CGPoint leftCenter=_leftControlView.center;
        leftCenter.x-=_rippleValue;
        _leftControlView.center=leftCenter;
        
        CGPoint bottomCenter=_bottomControlView.center;
        bottomCenter.y+=_rippleValue;
        _bottomControlView.center=bottomCenter;
        
        CGPoint rightCenter=_rightControlView.center;
        rightCenter.x+=_rippleValue;
        _rightControlView.center=rightCenter;
        
    } completion:^(BOOL finished) {
        
            [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.15 initialSpringVelocity:5.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                [self configerControlPoints];

            } completion:^(BOOL finished) {
                _animation=NO;
                [self stopLoop];
            }];
    }];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{

    [super setBackgroundColor:backgroundColor];
    _shapeLayer.fillColor=backgroundColor.CGColor;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_animation) {
        [self startLoop];
        [self animationtoToLayer];
    }
 
}
-(void)startLoop{
    self.displayLink.paused=NO;
}
-(void)stopLoop{

    self.displayLink.paused=YES;
}

@end
