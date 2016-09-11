//
//  TransformationVC.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/11.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "TransformationVC.h"
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5

@interface TransformationVC ()

@property (nonatomic,strong) CALayer *transLayer;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (nonatomic) CGAffineTransform transform;
@property (weak, nonatomic) IBOutlet UIButton *change3DBtn;
@property (nonatomic) CATransform3D transform3D;
@property (weak, nonatomic) IBOutlet UIView *playGroundView;
@property (weak, nonatomic) IBOutlet UIButton *cubeBtn;
@property (nonatomic,strong) NSMutableArray *faces;
@property (nonatomic) BOOL HasCreatCube;
@property (nonatomic)  CATransform3D perspective;
@end
@implementation TransformationVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.transLayer = [CALayer layer];
    self.transLayer.frame = CGRectMake(10, 74, 100, 100);
    self.transLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"Test"].CGImage);
    self.transform = CGAffineTransformIdentity;
    self.transform3D = CATransform3DIdentity;
    self.perspective = CATransform3DIdentity;
    [self.view.layer addSublayer:self.transLayer];
    
    self.playGroundView.hidden = YES;
    self.HasCreatCube = NO;
    [self.view bringSubviewToFront:self.changeBtn];
    [self.view bringSubviewToFront:self.change3DBtn];
    
}
- (void)animationByState:(void(^)(void))AnyAction{
    [UIView animateWithDuration:0.8 animations:^{
        AnyAction();
    }];
    
}
- (IBAction)change:(UIButton *)sender {
    static NSInteger n = 0;
    
    switch (n) {
        case 0:
        {
            self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2);
            self.transform = CGAffineTransformMakeShear(0, 0);
        }
            break;
        case 1:
        {
            self.transform = CGAffineTransformRotate(self.transform, M_PI_4);
        }
            break;
        case 2:
        {
            self.transform = CGAffineTransformMakeTranslation(arc4random()%200, arc4random()%200);
        }
            break;
        case 3:
        {
            self.transLayer.frame = CGRectMake(10, 74, 100, 100);
        }
            break;
        case 4:{
            self.transform = CGAffineTransformMakeShear(10, 10);
            
        }
            break;
        default:{
            n = 0;
            [self performSelector:@selector(change:) withObject:self.changeBtn];
        }
            break;
    }
    ++n;
    [self animationByState:^{
        self.transLayer.affineTransform = self.transform;
        self.playGroundView.hidden = YES;
    }];
  
    
}
- (IBAction)change3DBtn:(UIButton *)sender {
    //3D变换
    /*
     CG的前缀告诉我们，`CGAffineTransform`类型属于Core Graphics框架，Core Graphics实际上是一个严格意义上的2D绘图API，并且`CGAffineTransform`仅仅对2D变换有效。
     
     在第三章中，我们提到了`zPosition`属性，可以用来让图层靠近或者远离相机（用户视角），`transform`属性（`CATransform3D`类型）可以真正做到这点，即让图层在3D空间内移动或者旋转。
     
     和`CGAffineTransform`类似，`CATransform3D`也是一个矩阵，但是和2x3的矩阵不同，`CATransform3D`是一个可以在3维空间内做变换的4x4的矩阵
     和`CGAffineTransform`矩阵类似，Core Animation提供了一系列的方法用来创建和组合`CATransform3D`类型的矩阵，和Core Graphics的函数类似，但是3D的平移和旋转多处了一个`z`参数，并且旋转函数除了`angle`之外多出了`x`,`y`,`z`三个参数，分别决定了每个坐标轴方向上的旋转：
     
     CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
     CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
     CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
     
     分别以右和下为正方向，MacOS Z轴和这两个轴分别垂直，指向视角外为正方向。
     */
    CATransform3D transform = self.transform3D;
//    transform.m24 = -1.0 / 500.0;
    transform.m34 = - 1.0 / (arc4random()%1000);
//    transform = CATransform3DMakeRotation(M_PI, arc4random()%100/100.0, arc4random()%100/100.0, arc4random()%100/100.0);
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    [self animationByState:^{
        //自身的3dtransform
//        self.view.layer.transform = transform;
        
        //所有子涂层的transform
        self.view.layer.sublayerTransform = transform;
        self.playGroundView.hidden = YES;
    }];
    
    
}
- (IBAction)CubeClick:(UIButton *)sender {
    
    self.perspective = CATransform3DRotate(self.perspective, -M_PI_4*(arc4random()%10*10.0), arc4random()%10*10.0, arc4random()%10*10.0, arc4random()%10*10.0);
    
    [self animationByState:^{
        self.playGroundView.hidden = NO;
        [self.view.layer insertSublayer:self.transLayer atIndex:0];
        if (!self.HasCreatCube) {
            self.HasCreatCube = YES;
            [self creatCube];
        }else{
          
            self.playGroundView.layer.sublayerTransform = self.perspective;
            for (UIView *view in self.faces) {
//                [self applyLightingToFace:view.layer];
            }
        }
    }];
    
}
- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
    //get the face view and add it to the container
    UIView *face = self.faces[index];
    [self.playGroundView addSubview:face];
    //center the face view within the container
    CGSize containerSize = self.playGroundView.bounds.size;
    face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    // apply the transform
    face.layer.transform = transform;
//    [self applyLightingToFace:face.layer];
}
- (void)creatCube{
    /*
     struct CATransform3D
     {
     CGFloat     m11（x缩放）,    m12（y切变）,      m13（旋转）,     m14（）;
     
     CGFloat     m21（x切变）,    m22（y缩放）,      m23（）,             m24（）;
     
     CGFloat     m31（旋转）,      m32（ ）,               m33（）,               m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
     
     CGFloat     m41（x平移）,     m42（y平移）,     m43（z平移）,     m44（）;
     };
     
     */
    //set up the container sublayer transform
    CATransform3D perspective = self.perspective;
    perspective.m34 = -1.0 / 900.0;

    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    //add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    //add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
    
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.playGroundView.layer.sublayerTransform = perspective;
    
}
- (void)applyLightingToFace:(CALayer *)face
{
    //add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    //convert the face transform to matrix
    //(GLKMatrix4 has the same structure as CATransform3D)
    //译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    //get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    //get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    //set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}
- (NSMutableArray *)faces{
    if (!_faces) {
        _faces = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < 6; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
            lb.center = view.center;
            [view addSubview:lb];
            lb.text = [NSString stringWithFormat:@"%d",i];
            UIColor *randColor = [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:1.0f];
            view.backgroundColor = randColor;
//            view.backgroundColor = [UIColor whiteColor];
            [_faces addObject:view];
        }
    }
    return _faces;
}
CGAffineTransform CGAffineTransformMakeShear(CGFloat x, CGFloat y)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -x;
    transform.b = y;
    return transform;
}
@end
