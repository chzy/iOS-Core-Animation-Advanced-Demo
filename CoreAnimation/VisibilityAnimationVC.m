//
//  VisibilityAnimationVC.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/19.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "VisibilityAnimationVC.h"

@interface VisibilityAnimationVC ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIView *centerView;

@end

@implementation VisibilityAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.属性动画：（分为两种基础动画和关键帧动画）属性动画作用于图层的某个单一属性，并指定了它的一个目标值，或者一连串将要做动画的值
    [self startBasicAnmiation];
    
    //2.关键帧动画： *关键帧*起源于传动动画，意思是指主导的动画在显著改变发生时重绘当前帧（也就是*关键*帧），每帧之间剩下的绘制（可以通过关键帧推算出）将由熟练的艺术家来完成。`CAKeyframeAnimation`也是同样的道理：你提供了显著的帧，然后Core Animation在每帧之间进行插值
    [self startCAKeyframeAnimation];
}
/*
 `CABasicAnimation`是`CAPropertyAnimation`的一个子类，而`CAPropertyAnimation`的父类是`CAAnimation`，`CAAnimation`同时也是Core Animation所有动画类型的抽象基类。
 */
- (void)startBasicAnmiation{
    /*
     动画其实就是一段时间内发生的改变，最简单的形式就是从一个值改变到另一个值，这也是`CABasicAnimation`最主要的功能。
    
     `CAPropertyAnimation`通过指定动画的`keyPath`作用于一个单一属性，`CAAnimation`通常应用于一个指定的`CALayer`，于是这里指的也就是一个图层的`keyPath`了。实际上它是一个关键*路径*（一些用点表示法可以在层级关系中指向任意嵌套的对象），而不仅仅是一个属性的名称，因为这意味着动画不仅可以作用于图层本身的属性，而且还包含了它的子成员的属性，甚至是一些*虚拟*的属性
     `CABasicAnimation`继承于`CAPropertyAnimation`，并添加了如下属性：
     
     id fromValue
     id toValue
     id byValue
     
     从命名就可以得到很好的解释：`fromValue`代表了动画开始之前属性的值，`toValue`代表了动画结束之后的值，`byValue`代表了动画执行过程中改变的值。
     
     通过组合这三个属性就可以有很多种方式来指定一个动画的过程。它们被定义成`id`类型而不是一些具体的类型是因为属性动画可以用作很多不同种的属性类型，包括数字类型，矢量，变换矩阵，甚至是颜色或者图片。
     */
    self.view.layer.backgroundColor = [UIColor blueColor].CGColor;
    
}
CABasicAnimation *animation3;
- (void)startCAKeyframeAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 10.0f;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor ];
    //apply animation to layer
    [self.centerView.layer addAnimation:animation forKey:nil];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path addArcWithCenter:CGPointMake(150, 100) radius:125 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animation];
    animation2.keyPath = @"position";
    animation2.duration = 10.0;
    animation2.path = path.CGPath;
    animation2.rotationMode = kCAAnimationRotateAuto;
    [self.centerView.layer addAnimation:animation2 forKey:nil];
    
    //虚拟属性
    animation3 = [CABasicAnimation animation];
    animation3.keyPath = @"transform";
    animation3.duration = 10.0;
    
    animation3.fromValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0, 0, 0)];
    self.centerView.layer.transform = CATransform3DMakeRotation(M_PI, 0.5, 0.5, 0.5);
    
    animation3.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI/2.0, 0.5, 0.5, 0.5)];
    [self.centerView.layer addAnimation:animation3 forKey:nil];
    //更好的方法
    //这么做是可行的，但看起来更因为是运气而不是设计的原因，如果我们把旋转的值从`M_PI`（180度）调整到`2 * M_PI`（360度），然后运行程序，会发现这时候飞船完全不动了。这是因为这里的矩阵做了一次360度的旋转，和做了0度是一样的，所以最后的值根本没变
    //有一个更好的解决方案：为了旋转图层，我们可以对`transform.rotation`关键路径应用动画，而不是`transform`本身
    
    /*
     * 我们可以不通过关键帧一步旋转多于180度的动画。
     * 可以用相对值而不是绝对值旋转（设置`byValue`而不是`toValue`）。
     * 可以不用创建`CATransform3D`，而是使用一个简单的数值来指定角度。
     * 不会和`transform.position`或者`transform.scale`冲突（同样是使用关键路径来做独立的动画属性）。
     */
    animation3 = [CABasicAnimation animation];
    animation3.keyPath = @"transform.rotation";
    animation3.duration = 10.0;
    animation3.byValue = @(M_PI * 2);
    animation3.delegate = self;
    [self.centerView.layer addAnimation:animation3 forKey:nil];
    
    
}

CABasicAnimation *animation;
UIColor *color;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //create a basic animation
    animation = [CABasicAnimation animation];
    [self changeLayerBackgroundColor:color];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
    //apply animation to layer
    [self.view.layer addAnimation:animation forKey:animation.keyPath];
    
}
//动画并没有改变图层本身的 一旦动画结束并从图层上移除之后，图层就立刻恢复到之前定义的外观状态。从没改变过`backgroundColor`属性，所以图层就返回到原始的颜色。动画之前改变属性的值是最简单的办法，但这意味着我们不能使用`fromValue`这么好的特性了，而且要手动将`fromValue`设置成图层当前的值。
- (void)changeLayerBackgroundColor:(UIColor *)color{
    //动画开始之前设置颜色(动画之前改变属性的值是最简单的办法，但这意味着我们不能使用`fromValue`这么好的特性了，而且要手动将`fromValue`设置成图层当前的值。)
    if (/* DISABLES CODE */ (0)) {
        animation.fromValue = (__bridge id _Nullable)(self.view.layer.backgroundColor);
         self.view.layer.backgroundColor = color.CGColor;
    }else{
        //动画结束时设置颜色(解决看起来如此简单的一个问题都着实麻烦，但是别的方案会更加复杂。如果不在动画开始之前去更新目标属性，那么就只能在动画完全结束或者取消的时候更新它。这意味着我们需要精准地在动画结束之后，图层返回到原始值之前更新属性。那么该如何找到这个点呢？)
        animation.delegate = self;
    }

    
  
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (flag) {
        self.view.layer.backgroundColor = (__bridge CGColorRef _Nullable)(animation.toValue);
    }
    //跳转至动画组
//      [self performSegueWithIdentifier:@"GroupAniVCSegue" sender:self];
    
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
