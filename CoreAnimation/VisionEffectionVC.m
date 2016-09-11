//
//  VisionEffectionVC.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/11.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "VisionEffectionVC.h"

@interface VisionEffectionVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
@implementation VisionEffectionVC

- (void)viewDidLoad{
    [super viewDidLoad];
    //1.圆角 圆角矩形是iOS里面标志性审美特性。通过两个方法并就可以切圆角，
    /*
        CALayer有一个叫做`conrnerRadius`的属性控制着图层角的曲率。它是一个浮点数，默认为0（为0的时候就是直角），但是你可以把它设置成任意值。默认情况下，这个曲率值只影响背景颜色而不影响背景图片或是子图层。不过，如果把`masksToBounds`设置成YES的话，图层里面的所有东西都会被截取。
        也可以用 view 的clipsToBounds
     */
//    self.view.layer.masksToBounds = YES;
//    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = self.view.frame.size.width/2;
    
    //2.图层边框
    /*
     CALayer另外两个非常有用属性就是`borderWidth`和`borderColor`。二者共同定义了图层边的绘制样式。这条线（也被称作stroke）沿着图层的`bounds`绘制，同时也包含图层的角。
     */
    self.view.layer.borderWidth = 10;
    self.view.layer.borderColor = [UIColor redColor].CGColor;
    
    //3.阴影
    /*
     给`shadowOpacity`属性一个大于默认值（也就是0）的值，阴影就可以显示在任意图层之下。`shadowOpacity`是一个必须在0.0（不可见）和1.0（完全不透明）之间的浮点数。如果设置为1.0，将会显示一个有轻微模糊的黑色阴影稍微在图层之上。
     */
    self.view.layer.shadowOpacity = 0.5f;
    /*
       若要改动阴影的表现，你可以使用CALayer的另外三个属性：`shadowColor`，`shadowOffset`和`shadowRadius`。
     */
    /*
     `shadowColor`属性控制着阴影的颜色，和`borderColor`和`backgroundColor`一样，它的类型也是`CGColorRef`。阴影默认是黑色
     */
    self.view.layer.shadowColor = [UIColor greenColor].CGColor;
    
    /*
     `shadowOffset`属性控制着阴影的方向和距离。它是一个`CGSize`的值，宽度控制这阴影横向的位移，高度控制着纵向的位移。`shadowOffset`的默认值是 {0, -3}，意即阴影相对于Y轴有3个点的向上位移。
     */
    self.view.layer.shadowOffset = CGSizeMake(0, 1);
    /*
     注意 ：阴影是根据寄宿图的轮廓来确定的
     
     当阴影和裁剪扯上关系的时候就有一个头疼的限制：阴影通常就是在Layer的边界之外，如果你开启了`masksToBounds`属性，所有从图层中突出来的内容都会被才剪掉。如果我们在我们之前的边框示例项目中增加图层的阴影属性时，你就会发现问题所在。。（需要将裁剪禁止掉）
     */
    
    //4.shadowPath
    /*
     我们已经知道图层阴影并不总是方的，而是从图层内容的形状继承而来。这看上去不错，但是实时计算阴影也是一个非常消耗资源的，尤其是图层有多个子图层，每个图层还有一个有透明效果的寄宿图的时候。
     
     如果你事先知道你的阴影形状会是什么样子的，你可以通过指定一个`shadowPath`来提高性能。`shadowPath`是一个`CGPathRef`类型（一个指向`CGPath`的指针）。`CGPath`是一个Core Graphics对象，用来指定任意的一个矢量图形。我们可以通过这个属性单独于图层形状之外指定阴影的形状。
     
     */
    CGMutablePathRef squaraPath = CGPathCreateMutable();
    /*
     如果是一个矩形或者是圆，用`CGPath`会相当简单明了。但是如果是更加复杂一点的图形，`UIBezierPath`类会更合适，它是一个由UIKit提供的在CGPath基础上的Objective-C包装类。
     */
    CGPathAddRect(squaraPath, NULL, CGRectMake(0, 0, 100, 100));
    self.view.layer.shadowPath = squaraPath;
    
    CGPathRelease(squaraPath);
    
    //mask
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.imageView.bounds;
    UIImage *maskImage = [UIImage imageNamed:@"Test"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    //apply mask to image layer￼
    self.imageView.layer.mask = maskLayer;
    
    
    //5.拉伸过滤
    /*
     `minificationFilter`和`magnificationFilter`属性。总得来讲，当我们视图显示一个图片的时候，都应该正确地显示这个图片（意即：以正确的比例和正确的1：1像素显示在屏幕上）。原因如下：
     
     * 能够显示最好的画质，像素既没有被压缩也没有被拉伸。
     * 能更好的使用内存，因为这就是所有你要存储的东西。
     * 最好的性能表现，CPU不需要为此额外的计算。
     
     不过有时候，显示一个非真实大小的图片确实是我们需要的效果。比如说一个头像或是图片的缩略图，再比如说一个可以被拖拽和伸缩的大图。这些情况下，为同一图片的不同大小存储不同的图片显得又不切实际。
     
     当图片需要显示不同的大小的时候，有一种叫做*拉伸过滤*的算法就起到作用了。它作用于原图的像素上并根据需要生成新的像素显示在屏幕上。
     
     事实上，重绘图片大小也没有一个统一的通用算法。这取决于需要拉伸的内容，放大或是缩小的需求等这些因素。`CALayer`为此提供了三种拉伸过滤方法，他们是：
     
     * kCAFilterLinear
     * kCAFilterNearest
     * kCAFilterTrilinear
     
     minification（缩小图片）和magnification（放大图片）默认的过滤器都是`kCAFilterLinear`，这个过滤器采用双线性滤波算法，它在大多数情况下都表现良好。双线性滤波算法通过对多个像素取样最终生成新的值，得到一个平滑的表现不错的拉伸。但是当放大倍数比较大的时候图片就模糊不清了。
     
     `kCAFilterTrilinear`和`kCAFilterLinear`非常相似，大部分情况下二者都看不出来有什么差别。但是，较双线性滤波算法而言，三线性滤波算法存储了多个大小情况下的图片（也叫多重贴图），并三维取样，同时结合大图和小图的存储进而得到最后的结果。
     
     这个方法的好处在于算法能够从一系列已经接近于最终大小的图片中得到想要的结果，也就是说不要对很多像素同步取样。这不仅提高了性能，也避免了小概率因舍入错误引起的取样失灵的问题
     */
    
    self.imageView.layer.magnificationFilter =  kCAFilterNearest;
    
    //6.组透明
    /*
     UIView有一个叫做`alpha`的属性来确定视图的透明度。CALayer有一个等同的属性叫做`opacity`，这两个属性都是影响子层级的。也就是说，如果你给一个图层设置了`opacity`属性，那它的子图层都会受此影响。
     
     iOS常见的做法是把一个空间的alpha值设置为0.5（50%）以使其看上去呈现为不可用状态。对于独立的视图来说还不错，但是当一个控件有子视图的时候就有点奇怪了，图4.20展示了一个内嵌了UILabel的自定义UIButton；左边是一个不透明的按钮，右边是50%透明度的相同按钮。我们可以注意到，里面的标签的轮廓跟按钮的背景很不搭调。
     */
    
    self.view.layer.opacity = 0.5;
    self.imageView.layer.opacity = 0.9;
    self.view.layer.shouldRasterize = YES;
}
@end
