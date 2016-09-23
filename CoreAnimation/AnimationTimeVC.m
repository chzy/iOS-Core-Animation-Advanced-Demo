//
//  AnimationTimeVC.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/22.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "AnimationTimeVC.h"

@interface AnimationTimeVC ()

@end

@implementation AnimationTimeVC
/*
 @interface CAAnimation : NSObject<NSCoding, NSCopying, CAMediaTiming, CAAction>
 
 ##`CAMediaTiming`协议
 `CAMediaTiming`协议定义了在一段动画内用来控制逝去时间的属性的集合，`CALayer`和`CAAnimation`都实现了这个协议，所以时间可以被任意基于一个图层或者一段动画的类控制。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
  
    CALayer *doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 128, 256);
    doorLayer.position = CGPointMake(150 - 64, 250);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id)[UIImage imageNamed: @"door.jpg"].CGImage;
    [self.view.layer addSublayer:doorLayer];
    //apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = perspective;
    //apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 2.0;
    //repeatDuration重复次数 INFINITY非常大的数字
    animation.repeatDuration = 1;
    
    //返回执行上次的动画，顺序相反
    animation.autoreverses = YES;
    
    //默认时间 为0   即指定了动画开始之前的的延迟时间
    animation.beginTime = 0;
    
    //是一个时间的倍数，默认1.0，减少它会减慢图层/动画的时间，增加它会加快速度。如果2.0的速度，那么对于一个`duration`为1的动画，实际上在0.5秒的时候就已经完成了 为0则表示暂停 ，为大于 1则表示加速  等于一则表示 默认速度
    animation.speed = 0.2f;
    
    //动画时间偏移量 0.5意味着动画将从一半的地方开始
    animation.timeOffset = 0.5;
    
    //动画完成 是否移除动画状态
    [animation setRemovedOnCompletion:NO];
    
    //保持到那一帧
    
     /* `fillMode' options. */
    /*
    CA_EXTERN NSString * const kCAFillModeForwards
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAFillModeBackwards
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAFillModeBoth
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAFillModeRemoved
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
     */
    animation.fillMode = kCAFillModeForwards;
    
    [doorLayer addAnimation:animation forKey:nil];
   
    
//    CFTimeInterval time = CACurrentMediaTime();
    
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
