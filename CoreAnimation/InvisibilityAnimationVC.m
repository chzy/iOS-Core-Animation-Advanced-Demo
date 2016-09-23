//
//  InvisibilityAnimationVC.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/13.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "InvisibilityAnimationVC.h"

@interface InvisibilityAnimationVC ()
@property (nonatomic,strong) CALayer *animationLayer;
@end
@implementation InvisibilityAnimationVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame  = self.view.frame;
    [self.view.layer addSublayer:self.animationLayer];
    
    self.animationLayer.beginTime = 1;
    self.animationLayer.timeOffset = 3;
    self.animationLayer.backgroundColor = [UIColor redColor].CGColor;
    self.view.backgroundColor = [UIColor blackColor];
}
//- (IBAction)Click:(UIButton *)sender {
//    //randomize the layer background color
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.animationLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//    
//}
/*
 这其实就是所谓的*隐式*动画。之所以叫隐式是因为我们并没有指定任何动画的类型。我们仅仅改变了一个属性
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
     red = arc4random() / (CGFloat)INT_MAX;
     green = arc4random() / (CGFloat)INT_MAX;
     blue = arc4random() / (CGFloat)INT_MAX;
    self.animationLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    /*
     事务实际上是Core Animation用来包含一系列属性动画集合的机制，任何用指定事务去改变可以做动画的图层属性都不会立刻发生变化，而是当事务一旦*提交*的时候开始用一个动画过渡到新值。
     
     事务是通过`CATransaction`类来做管理，这个类的设计有些奇怪，不像你从它的命名预期的那样去管理一个简单的事务，而是管理了一叠你不能访问的事务。`CATransaction`没有属性或者实例方法，并且也不能用`+alloc`和`-init`方法创建它。但是可以用`+begin`和`+commit`分别来入栈或者出栈
     */
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0f];
    self.animationLayer.affineTransform = CGAffineTransformScale(self.animationLayer.affineTransform, 0.99f, 0.99f);
    
    [CATransaction setCompletionBlock:^{
        NSLog(@"变色完毕");
        self.animationLayer.affineTransform = CGAffineTransformScale(self.animationLayer.affineTransform, 0.99f, 0.99f);
        self.animationLayer.affineTransform = CGAffineTransformRotate(self.animationLayer.affineTransform, M_PI_4/10);
        NSLog(@"self.animationLayer%@",[self.view actionForLayer:self.animationLayer forKey:@"backgroundColor"]);
    }];
    [CATransaction commit];
    
}
/*
 隐式动画的禁止
 */
- (IBAction)Click:(UIButton *)sender {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    red = arc4random() / (CGFloat)INT_MAX;
    green = arc4random() / (CGFloat)INT_MAX;
    blue = arc4random() / (CGFloat)INT_MAX;
    
    [UIView beginAnimations:nil context:nil];
    sender.layer.backgroundColor =  [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    sender.layer.frame = CGRectMake(sender.frame.origin.x+arc4random()%20 - 10, sender.frame.origin.y+arc4random()%20 - 10, sender.frame.size.width+arc4random()%20 - 10, sender.frame.size.height+arc4random()%20 - 10);
    NSLog(@"BTN 的隐式动画: %@", [sender actionForLayer:sender.layer forKey:@"backgroundColor"]);
    
    //当按下按钮，按钮的图层颜色瞬间切换到新的值，而不是之前平滑过渡的动画。 没有动画 因为UIKit将隐式动画禁止了
    /*
     改变属性时`CALayer`自动应用的动画称作*行为*，当`CALayer`的属性被修改时候，它会调用`-actionForKey:`方法，传递属性的名称。剩下的操作都在`CALayer`的头文件中有详细的说明，实质上是如下几步：
     
     * 图层首先检测它是否有委托，并且是否实现`CALayerDelegate`协议指定的`-actionForLayer:forKey`方法。如果有，直接调用并返回结果。
     * 如果没有委托，或者委托没有实现`-actionForLayer:forKey`方法，图层接着检查包含属性名称对应行为映射的`actions`字典。
     * 如果`actions字典`没有包含对应的属性，那么图层接着在它的`style`字典接着搜索属性名。
     * 最后，如果在`style`里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的`-defaultActionForKey:`方法。
     
     所以一轮完整的搜索结束之后，`-actionForKey:`要么返回空（这种情况下将不会有动画发生），要么是`CAAction`协议对应的对象，最后`CALayer`拿这个结果去对先前和当前的值做动画。
     
     于是这就解释了UIKit是如何禁用隐式动画的：每个`UIView`对它关联的图层都扮演了一个委托，并且提供了`-actionForLayer:forKey`的实现方法。当不在一个动画块的实现中，`UIView`对所有图层行为返回`nil`，但是在动画block范围之内，它就返回了一个非空值。
     */
    
}

@end
