//
//  CircleRippleView.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/10.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "CircleRippleView.h"
@interface CircleRippleView ()

@property (nonatomic, strong) CAShapeLayer *circleShapeLayer;

@end

@implementation CircleRippleView

//构造函数
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpLayers];
    }
    return self;
}

//创建动画视图
- (void)setUpLayers
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.circleShapeLayer = [CAShapeLayer layer];
    _circleShapeLayer.bounds = CGRectMake(0, 0, width, width);
    _circleShapeLayer.position = CGPointMake(width / 2.0, height / 2.0);
    //用贝塞尔画圆
    _circleShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)].CGPath;
    //圆圈颜色
    _circleShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    //View视图的透明度
    _circleShapeLayer.opacity = 0.0;
    
    //CAReplicatorLayer可以将自己的子图层复制指定的次数,并且复制体会保持被复制图层的各种基础属性以及动画
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.bounds = CGRectMake(0, 0, width, width);
    replicator.position = CGPointMake(width / 2.0, width / 2.0);
    //在短时间内的复制延时,一般用在动画上(支持动画的延时)
    replicator.instanceDelay = 0.8;
    //拷贝图层的次数,包括其所有的子图层,默认值是1,也就是没有任何子图层被复制
    replicator.instanceCount = 3;
    [replicator addSublayer:_circleShapeLayer];
    [self.layer addSublayer:replicator];
}

//开始动画
- (void)startAnimation
{
    NSLog(@"开始波纹动画");
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //改变属性的起始值，数值越大，展示圆圈越大
    alphaAnim.fromValue = [NSNumber numberWithFloat:0.6];
    //属性结束时的值
    alphaAnim.toValue = [NSNumber numberWithFloat:0.0];
    //
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 0.0, 0.0, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    CATransform3D t3 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    //动画组
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    //添加动画
    groupAnimation.animations = @[alphaAnim, scaleAnim];
    //动画时长数值大动画越慢（应该优化成音量来控制）
    groupAnimation.duration = 3.0;
//    groupAnimation.speed
    //结束时是否执行逆动画
    groupAnimation.autoreverses = YES;
    //重复次数 HUGE不停重复
    groupAnimation.repeatCount = HUGE;
    
    [_circleShapeLayer addAnimation:groupAnimation forKey:nil];
}

//结束动画
- (void)stopAnimation
{
    NSLog(@"结束波纹动画");
    [_circleShapeLayer removeAllAnimations];
}
@end
