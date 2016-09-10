//
//  BoardLayerVC.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/9.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "BoardLayerVC.h"

@implementation BoardLayerVC
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadLayerImageByAimageStr:@"Test"];
}
- (void)loadLayerImageByAimageStr:(NSString *)imageStr{
    UIImage *aimage = [UIImage imageNamed:imageStr];
    self.view.layer.contents = (__bridge id _Nullable)(aimage.CGImage);
    
    
    /**
     *  对其方式 与 view中的 contentMode类似
     */
      self.view.layer.contentsGravity = kCAGravityResizeAspect;
    
    /**
     *  
     当 self.view.layer.contentsGravity 不是
     * kCAGravityResize
     * kCAGravityResizeAspect
     * kCAGravityResizeAspectFill;
     中的一个时。
     
     self.view.layer.contentsScale = 2.5f;
     设置有效
     */
    self.view.layer.contentsScale = 2.5f;
    
    
    /**
     *  masksToBounds 类似于clipstoBounds
        裁掉超出边界的部分
     */
//    self.view.layer.masksToBounds = YES;
    
//    self.view.layer.contentsRect = CGRectMake(0.5, 0.5, 0.25, 0.25);
    
    /**
     * 
     给`contents`赋CGImage的值不是唯一的设置寄宿图的方法。我们也可以直接用Core Graphics直接绘制寄宿图。能够通过继承UIView并实现`-drawRect:`方法来自定义绘制。
     
     `-drawRect:` 方法没有默认的实现，因为对UIView来说，寄宿图并不是必须的，它不在意那到底是单调的颜色还是有一个图片的实例。如果UIView检测到`-drawRect:` 方法被调用了，它就会为视图分配一个寄宿图，这个寄宿图的像素尺寸等于视图大小乘以 `contentsScale`的值。
     
     如果你不需要寄宿图，那就不要创建这个方法了，这会造成CPU资源和内存的浪费，这也是为什么苹果建议：如果没有自定义绘制的任务就不要在子类中写一个空的-drawRect:方法。
     
     当视图在屏幕上出现的时候 `-drawRect:`方法就会被自动调用。`-drawRect:`方法里面的代码利用Core Graphics去绘制一个寄宿图，然后内容就会被缓存起来直到它需要被更新（通常是因为开发者调用了`-setNeedsDisplay`方法，尽管影响到表现效果的属性值被更改时，一些视图类型会被自动重绘，如`bounds`属性）。虽然`-drawRect:`方法是一个UIView方法，事实上都是底层的CALayer安排了重绘工作和保存了因此产生的图片。
     */
    
    
    
    
}
@end
