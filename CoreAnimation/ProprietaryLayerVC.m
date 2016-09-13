//
//  ProprietaryLayer.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/11.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "ProprietaryLayerVC.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>
#import "GAEGLLayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ProprietaryTableCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLb;

@end
@implementation ProprietaryTableCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end
@interface ProprietaryLayerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic,strong) UIScrollView *scrollView;
@end
@implementation ProprietaryLayerVC
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.dataSource addObject:@"CAShapLayer"];
    [self.dataSource addObject:@"CAtextLayer"];
    [self.dataSource addObject:@"RichText"];
    [self.dataSource addObject:@"CAGradientLayer"];
    [self.dataSource addObject:@"CAReplicatorLayer"];
    [self.dataSource addObject:@"CAScrollLayer"];
    [self.dataSource addObject:@"CATiledLayer"];
    [self.dataSource addObject:@"CAEmitterLayer"];
    [self.dataSource addObject:@"CAEAGLLayer"];
    [self.dataSource addObject:@"AVPlayerLayer"];
//    self.automaticallyAdjustsScrollViewInsets  = NO;
}
CATiledLayer *tileLayer;
#pragma mark =====================APPDelegate==========================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //去除tileLayer的代理防止崩溃
    if (tileLayer) {
        [self.scrollView removeFromSuperview];
        tileLayer.delegate = nil;
        [tileLayer removeFromSuperlayer];
        tileLayer = nil;
    }
    for (int i = 0 ; i < self.backgroundView.layer.sublayers.count; i ++) {
        
            [(CALayer *) self.backgroundView.layer.sublayers[i] removeFromSuperlayer];
        
    }
//    [self.scrollView removeFromSuperview];
   
    switch (indexPath.row) {
        case 0:
        {
            [self addShapeLayer];
        }
            break;
        case 1:
        {
            [self addTextLayer];
        }
            break;
        case 2:
        {
            [self addRichText];
        }
            break;
        case 3:{
            [self addGradient];
        }
            break;
        case 4:{
            [self addCAReplicatorLayer];
        }
            break;
        case 5:{
            [self addCAScrollLayer];
        }
            break;
        case 6:{
            [self addCATiledLayer];
            [self.backgroundView addSubview:self.scrollView];
        }
            break;
        case 7:{
            [self addCAEmitterLayer];
        }
            break;
        case 8:{
            [self addCAEAGLLayer];
        }
            break;
        case 9:{
            [self addAVPlayerLayer];
        }
            break;
        default:
            break;
    }
    
}
//ShapeLayer
- (void)addShapeLayer{
    UIBezierPath *path = [[UIBezierPath alloc] init];

    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 10;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    //add it to our view
    [self.backgroundView.layer addSublayer:shapeLayer];
    /* 承接视觉 VisionEffectionVC 可以做图蒙版
    //mask
    CALayer *maskLayer = shapeLayer;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.backgroundView.frame];
    [self.view addSubview:imageView];
    UIImage *maskImage = [UIImage imageNamed:@"Test"];
    imageView.image = maskImage;
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    //apply mask to image layer￼
    imageView.layer.mask = maskLayer;
    */
    
}
//TextShapeLayer
- (void)addTextLayer{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.backgroundView.bounds;
    [self.backgroundView.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \n elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar  leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, \nlibero ut porttitor dictum,😆\n diam odio congue lacus, vel  fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet  lobortis";
    
    //set layer text
    textLayer.string = text;
    /*
     `CATextLayer`的`font`属性不是一个`UIFont`类型，而是一个`CFTypeRef`类型。这样可以根据你的具体需要来决定字体属性应该是用`CGFontRef`类型还是`CTFontRef`类型（Core Text字体）。同时字体大小也是用`fontSize`属性单独设置的，因为`CTFontRef`和`CGFontRef`并不像UIFont一样包含点大小。这个例子会告诉你如何将`UIFont`转换成`CGFontRef`。
     
     另外，`CATextLayer`的`string`属性并不是你想象的`NSString`类型，而是`id`类型。这样你既可以用`NSString`也可以用`NSAttributedString`来指定文本了（注意，`NSAttributedString`并不是`NSString`的子类）。属性化字符串是iOS用来渲染字体风格的机制，它以特定的方式来决定指定范围内的字符串的原始信息，比如字体，颜色，字重，斜体等。
    如下富文本。。。。。
     */
    
    //for retina screen
    textLayer.contentsScale = [UIScreen mainScreen].scale;
}
//富文本
- (void)addRichText{
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.backgroundView.bounds;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.backgroundView.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \n elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \n leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc \n elementum, libero ut porttitor dictum, diam odio congue lacus, vel \n fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet  lobortis";
    //create attributed string
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:text];
    
    //convert UIFont to a CTFont
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    //set text attributes
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                              };
    
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    //release the CTFont we created earlier
    CFRelease(fontRef);
    
    //set layer text
    textLayer.string = string;
}
//CAGradientLayer 梯度渐变
- (void)addGradient{
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.backgroundView.bounds;
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor purpleColor].CGColor];
    [self.backgroundView.layer addSublayer:layer];
    //变换开始点和结束点（范围比例）
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0.25, 0.75);
    layer.locations = @[@0.0,@0.5,@0.8];
}
//重复图层
- (void)addCAReplicatorLayer{
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.backgroundView.bounds;
    [self.backgroundView.layer addSublayer:replicator];
    
    //configure the replicator
    replicator.instanceCount = 10;
    
    //相当于做instanceCount遍以下递归
    //apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
//    transform = CATransform3DTranslate(transform, 0, 60.0f+2, -60);
    transform = CATransform3DRotate(transform, M_PI_2/5, 0, 1, 1);
    transform.m34 = -1.0 / 1000.0;
    replicator.instanceTransform = transform;
    
    //apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    replicator.instanceRedOffset = -0.1;
    replicator.instanceAlphaOffset = -0.01;
    
    //create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [replicator addSublayer:layer];
    
}
//可滑动图层
CAScrollLayer *textlayer;

- (void)addCAScrollLayer{
    textlayer = [CAScrollLayer layer];
    textlayer.frame = self.backgroundView.bounds;
    self.backgroundView.layer.masksToBounds = YES;
//    textlayer.affineTransform = CGAffineTransformTranslate(textlayer.affineTransform, 300, textlayer.frame.origin.y);
    
    CALayer *contentLayer =[CALayer layer];
    contentLayer.frame = CGRectMake(10, 10, 400, 800);
    contentLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"Test"].CGImage);
    [self.backgroundView.layer addSublayer:textlayer];
    [textlayer addSublayer:contentLayer];
    
    
    textlayer.contentsGravity = kCAGravityBottomRight;
    textlayer.scrollMode = kCAScrollBoth;
    UIPanGestureRecognizer *recognizer = nil;
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.backgroundView addGestureRecognizer:recognizer];
}
- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint origin = textlayer.bounds.origin;
    origin = CGPointMake(origin.x - translation.x, origin.y - translation.y);
    [textlayer scrollToPoint:origin];
    [recognizer setTranslation:CGPointZero inView:self.view];
    
}
//addCATiledLayer
- (void)addCATiledLayer{
    /*
     有些时候你可能需要绘制一个很大的图片，常见的例子就是一个高像素的照片或者是地球表面的详细地图。iOS应用通畅运行在内存受限的设备上，所以读取整个图片到内存中是不明智的。载入大图可能会相当地慢，那些对你看上去比较方便的做法（在主线程调用`UIImage`的`-imageNamed:`方法或者`-imageWithContentsOfFile:`方法）将会阻塞你的用户界面，至少会引起动画卡顿现象。
     
     能高效绘制在iOS上的图片也有一个大小限制。所有显示在屏幕上的图片最终都会被转化为OpenGL纹理，同时OpenGL有一个最大的纹理尺寸（通常是2048\*2048，或4096\*4096，这个取决于设备型号）。如果你想在单个纹理中显示一个比这大的图，即便图片已经存在于内存中了，你仍然会遇到很大的性能问题，因为Core Animation强制用CPU处理图片而不是更快的GPU（见第12章『速度的曲调』，和第13章『高效绘图』，它更加详细地解释了软件绘制和硬件绘制）。
     
     `CATiledLayer`为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片然后将他们单独按需载入。
     */
    tileLayer = [CATiledLayer layer];
    tileLayer.frame = CGRectMake(0, 0, 2048, 2048);
    tileLayer.delegate = self;
    [self.scrollView.layer addSublayer:tileLayer];
//    tileLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"Test"].CGImage);
    //configure the scroll view
    tileLayer.contents = nil;
    self.scrollView.contentSize = tileLayer.frame.size;
    [self.scrollView.layer addSublayer:tileLayer];
//    self.scrollView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"Test"].CGImage);
    //draw layer
    [tileLayer setNeedsDisplay];
}
- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    //determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
//    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
//    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
    
    //load tile image
//    NSString *imageName = [NSString stringWithFormat: @"Test", x, y];
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
//    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"图片2" ofType:@"jpeg"]];
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
}
//CAEmitterLayer粒子效果
- (void)addCAEmitterLayer{
/*
 在iOS 5中，苹果引入了一个新的`CALayer`子类叫做`CAEmitterLayer`。`CAEmitterLayer`是一个高性能的粒子引擎，被用来创建实时例子动画如：烟雾，火，雨等等这些效果。
 
 `CAEmitterLayer`看上去像是许多`CAEmitterCell`的容器，这些`CAEmitierCell`定义了一个例子效果。你将会为不同的例子效果定义一个或多个`CAEmitterCell`作为模版，同时`CAEmitterLayer`负责基于这些模版实例化一个粒子流。一个`CAEmitterCell`类似于一个`CALayer`：它有一个`contents`属性可以定义为一个`CGImage`，另外还有一些可设置属性控制着表现和行为。我们不会对这些属性逐一进行详细的描述，你们可以在`CAEmitterCell`类的头文件中找到。
 */
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.frame = CGRectMake(self.view.frame.size.width/2 - 25, 150, 50, 50);
    emitterLayer.preservesDepth = YES;
    [self.backgroundView.layer addSublayer:emitterLayer];
    
    //configure emitter
    emitterLayer.renderMode = kCAEmitterLayerAdditive;
    emitterLayer.emitterPosition = CGPointMake(emitterLayer.frame.size.width / 2.0, emitterLayer.frame.size.height / 2.0);
    
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"fire"].CGImage;
    //同时存在几个粒子
    cell.birthRate = 6;
    //每一个粒子的生命时间
    cell.lifetime = 2;
    //颜色变换
    cell.color = [UIColor colorWithRed:0.18 green:0.95 blue:0.91 alpha:1.0].CGColor;
    //透明度变换
    cell.alphaSpeed = -0.4;
    //移动速度
    cell.velocity = 100;
    cell.velocityRange = -50;
    // 粒子某一属性的变化范围。比如`emissionRange`属性的值是2π，这意味着粒子可以从360度任意位置反射出来。如果指定一个小一些的值，就可以创造出一个圆锥形。
    cell.emissionRange = M_PI * 2.0;
//    cell.emissionRange = -M_PI;
    //add particle template to emitter
    emitterLayer.emitterCells = @[cell];
    
}
- (void)addCAEAGLLayer{
    /*
     当iOS要处理高性能图形绘制，必要时就是OpenGL。应该说它应该是最后的杀手锏，至少对于非游戏的应用来说是的。因为相比Core Animation和UIkit框架，它不可思议地复杂。
     
     OpenGL提供了Core Animation的基础，它是底层的C接口，直接和iPhone，iPad的硬件通信，极少地抽象出来的方法。OpenGL没有对象或是图层的继承概念。它只是简单地处理三角形。OpenGL中所有东西都是3D空间中有颜色和纹理的三角形。用起来非常复杂和强大，但是用OpenGL绘制iOS用户界面就需要很多很多的工作了。
     
     为了能够以高性能使用Core Animation，你需要判断你需要绘制哪种内容（矢量图形，例子，文本，等等），但后选择合适的图层去呈现这些内容，Core Animation中只有一些类型的内容是被高度优化的；所以如果你想绘制的东西并不能找到标准的图层类，想要得到高性能就比较费事情了。
     
     因为OpenGL根本不会对你的内容进行假设，它能够绘制得相当快。利用OpenGL，你可以绘制任何你知道必要的集合信息和形状逻辑的内容。所以很多游戏都喜欢用OpenGL（这些情况下，Core Animation的限制就明显了：它优化过的内容类型并不一定能满足需求），但是这样依赖，方便的高度抽象接口就没了。
     
     在iOS 5中，苹果引入了一个新的框架叫做GLKit，它去掉了一些设置OpenGL的复杂性，提供了一个叫做`CLKView`的`UIView`的子类，帮你处理大部分的设置和绘制工作。前提是各种各样的OpenGL绘图缓冲的底层可配置项仍然需要你用`CAEAGLLayer`完成，它是`CALayer`的一个子类，用来显示任意的OpenGL图形。
     
     大部分情况下你都不需要手动设置`CAEAGLLayer`（假设用GLKView），过去的日子就不要再提了。特别的，我们将设置一个OpenGL ES 2.0的上下文，它是现代的iOS设备的标准做法。
     
     尽管不需要GLKit也可以做到这一切，但是GLKit囊括了很多额外的工作，比如设置顶点和片段着色器，这些都以类C语言叫做GLSL自包含在程序中，同时在运行时载入到图形硬件中。编写GLSL代码和设置`EAGLayer`没有什么关系，所以我们将用`GLKBaseEffect`类将着色逻辑抽象出来。其他的事情，我们还是会有以往的方式。
     
     在开始之前，你需要将GLKit和OpenGLES框架加入到你的项目中，然后就可以实现清单6.14中的代码，里面是设置一个`GAEAGLLayer`的最少工作，它使用了OpenGL ES 2.0 的绘图上下文，并渲染了一个有色三角
     */
#warning   略复杂。后面再细看
    
    [self.navigationController pushViewController:[[GAEGLLayer alloc] init] animated:YES];
    
}
- (void)addAVPlayerLayer{
//    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"mp4" withExtension:@"mp4"];
   //网络资源
        NSURL *net_URL = [NSURL URLWithString:@"http://baobab.wandoujia.com/api/v1/playUrl?vid=9264&editionType=default"];
        AVPlayer *player = [AVPlayer playerWithURL:net_URL];
    
//    本地
    NSString *path = [[NSBundle mainBundle]pathForResource:@"local" ofType:@"mov"];
    NSURL *URL = [NSURL fileURLWithPath:path];
    AVAsset *movieAsset = [AVURLAsset assetWithURL:URL];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.backgroundView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.backgroundView.layer addSublayer:playerLayer];
    [playerLayer setPlayer:player];
    //play the video
    [player play];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLIDE = @"ProprietaryTableCell";
    ProprietaryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    if (!cell) {
        cell = [[ProprietaryTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDE];
    }
    cell.infoLb.text = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.backgroundView.bounds];
    }
    return _scrollView;
}
@end
