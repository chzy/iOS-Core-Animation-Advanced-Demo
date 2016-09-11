//
//  LayerGeometryVC.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/10.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "LayerGeometryVC.h"

@interface LayerGeometryVC ()<NSLayoutManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *hourImV;

@property (weak, nonatomic) IBOutlet UIImageView *minuteImV;

@property (weak, nonatomic) IBOutlet UIImageView *secondImV;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImV;

@property (nonatomic, strong)NSTimer *timer;

@end
@implementation LayerGeometryVC
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view sendSubviewToBack:self.backgroundImV];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(working) userInfo:nil repeats:YES];
    
    //当使用视图的时候，可以充分利用`UIView`类接口暴露出来的`UIViewAutoresizingMask`和`NSLayoutConstraint`API，但如果想随意控制`CALayer`的布局，就需要手工操作。最简单的方法就是使用``如下函数：
    // self.secondImV.layer.delegate = self;()
    // - (void)layoutSublayersOfLayer:(CALayer *)layer;
    //   当图层的`bounds`发生改变，或者图层的`-setNeedsLayout`方法被调用的时候，这个函数将会被执行。这使得你可以手动地重新摆放或者重新调整子图层的大小，但是不能像`UIView`的`autoresizingMask`和`constraints`属性做到自适应屏幕旋转。
    [self working];
}
- (void)working{
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:[NSDate date]];
    
    CGFloat hourAngle = components.hour/12.0*M_PI*2.0- M_PI*0.5;
    
    CGFloat minuteAngle = components.minute/60.0*M_PI*2.0- M_PI*0.5;
    
    CGFloat secondAngle = components.second/60.0*M_PI*2.0 - M_PI*0.5;
    NSLog(@"%@",components);
    self.hourImV.layer.anchorPoint = self.minuteImV.layer.anchorPoint = self.secondImV.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
    
    self.hourImV.transform = CGAffineTransformMakeRotation(hourAngle);
    self.minuteImV.transform = CGAffineTransformMakeRotation(minuteAngle);
    self.secondImV.transform = CGAffineTransformMakeRotation(secondAngle);
    
    self.hourImV.hidden = NO;
    self.minuteImV.hidden = NO;
    self.secondImV.hidden = NO;
    
    //坐标转换补充
    /**
     * 
     // 将像素point由point所在视图转换到目标视图view中，返回在目标视图view中的像素值
     - (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view;
     // 将像素point从view中转换到当前视图中，返回在当前视图中的像素值
     - (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)view;
     
     // 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
     - (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;
     // 将rect从view中转换到当前视图中，返回在当前视图中的rect
     - (CGRect)convertRect:(CGRect)rect fromView:(UIView *)view;
     
     例把UITableViewCell中的subview(btn)的frame转换到 controllerA中
     [objc] view plain copy 在CODE上查看代码片派生到我的代码片
     // controllerA 中有一个UITableView, UITableView里有多行UITableVieCell，cell上放有一个button
     // 在controllerA中实现:
     CGRect rc = [cell convertRect:cell.btn.frame toView:self.view];
     或
     CGRect rc = [self.view convertRect:cell.btn.frame fromView:cell];
     // 此rc为btn在controllerA中的rect
     
     或当已知btn时：
     CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
     或  
     CGRect rc = [self.view convertRect:btn.frame fromView:btn.superview];
     */
    //与上面的坐标转换类似 layer 层也有对应的坐标转换
    /**
     * 
     ##坐标系
     和视图一样，图层在图层树当中也是相对于父图层按层级关系放置，一个图层的`position`依赖于它父图层的`bounds`，如果父图层发生了移动，它的所有子图层也会跟着移动。
     
     这样对于放置图层会更加方便，因为你可以通过移动根图层来将它的子图层作为一个整体来移动，但是有时候你需要知道一个图层的*绝对*位置，或者是相对于另一个图层的位置，而不是它当前父图层的位置。
     
     `CALayer`给不同坐标系之间的图层转换提供了一些工具类方法：
     
     - (CGPoint)convertPoint:(CGPoint)point fromLayer:(CALayer *)layer;
     - (CGPoint)convertPoint:(CGPoint)point toLayer:(CALayer *)layer;
     - (CGRect)convertRect:(CGRect)rect fromLayer:(CALayer *)layer;
     - (CGRect)convertRect:(CGRect)rect toLayer:(CALayer *)layer;
     
     这些方法可以把定义在一个图层坐标系下的点或者矩形转换成另一个图层坐标系下的点或者矩形
     */
    
    //与uiview的坐标系不同的是：CALayer 是存在于一个三维空间中的，除了上述属性外（position==同于view的center和anchor）还有另外两个属性'zPosition'和'anchorPositionZ'两者都是在Z轴上描述图层位置的浮点型
    
    //涂层树
    /**
     *
     `CALayer`并不关心任何响应链事件，所以不能直接处理触摸事件或者手势。但是它有一系列的方法帮你处理事件：`-containsPoint:`和`-hitTest:`。
     
     ` -containsPoint: `接受一个在本图层坐标系下的`CGPoint`，如果这个点在图层`frame`范围内就返回`YES`。
 
     ` -hitTest: `返回当前触控的layer
     */
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject]locationInView:self.view];
    if (self.secondImV.layer == [self.view.layer hitTest:point]) {
      UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"秒针"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
         [alert show];
    }
    
    if (self.minuteImV.layer == [self.view.layer hitTest:point]) {
         UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"分针"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] ;
        [alert show];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    
}
//-(void)layoutSublayersOfLayer:(CALayer *)layer{
// 
//    
//}
@end
