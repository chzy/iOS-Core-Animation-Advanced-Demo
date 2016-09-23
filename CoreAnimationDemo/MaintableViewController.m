//
//  MaintableViewController.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/9.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "MaintableViewController.h"
#import "MaintbaleViewCell.h"

@implementation MaintableViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"CoreAnimation";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadData];
}
- (void)loadData{
    self.dataSource = [[NSMutableArray alloc]init];
    [self.dataSource addObject:[self setModelBy:@"寄宿图" andVCName:@"BoardLayerVC"]];
    [self.dataSource addObject:[self setModelBy:@"图层几何学" andVCName:@"LayerGeometryVC"]];
    [self.dataSource addObject:[self setModelBy:@"视觉效果" andVCName:@"VisionEffectionVC"]];
    [self.dataSource addObject:[self setModelBy:@"变换" andVCName:@"TransformationVC"]];
    [self.dataSource addObject:[self setModelBy:@"专有图层" andVCName:@"ProprietaryLayerVC"]];
    [self.dataSource addObject:[self setModelBy:@"隐式动画" andVCName:@"InvisibilityAnimationVC"]];
    [self.dataSource addObject:[self setModelBy:@"显式动画" andVCName:@"VisibilityAnimationVC"]];
    [self.dataSource addObject:[self setModelBy:@"图层时间" andVCName:@"AnimationTimeVC"]];
    [self.dataSource addObject:[self setModelBy:@"缓冲" andVCName:@"BufferVC"]];
    
    [self.tableView reloadData];
}
- (MaintableCellModel *)setModelBy:(NSString *)aString andVCName:(NSString *)aClassName{
    MaintableCellModel *model = [[MaintableCellModel alloc]init];
    model.titleStr = aString;
    model.vCStr = aClassName;
    return model;
}
#pragma  mark ================TableView Delegate============================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLIDE = @"maintable cell ide";
    MaintbaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    if (!cell) {
        cell = [[MaintbaleViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDE];
    }
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MaintableCellModel *model = self.dataSource[indexPath.row];
    if ([model.vCStr isEqualToString:@"BoardLayerVC"]) {
        [self performSegueWithIdentifier:@"BoardLayerSegue" sender:self];
    }
    if ([model.vCStr isEqualToString:@"LayerGeometryVC"]) {
        [self performSegueWithIdentifier:@"LayerGeometrySegue" sender:self];
    }
    if ([model.vCStr isEqualToString:@"VisionEffectionVC"]) {
        [self performSegueWithIdentifier:@"VisionEffectionSegue" sender:self];
    }
    if ([model.vCStr isEqualToString:@"TransformationVC"]) {
        [self performSegueWithIdentifier:@"TransformationSegue" sender:self];
    }
    if ([model.vCStr isEqualToString:@"ProprietaryLayerVC"]) {
        [self performSegueWithIdentifier:@"ProprietaryLayerSegue" sender:self];
    }
    if ([model.vCStr isEqualToString:@"InvisibilityAnimationVC"]) {
        [self performSegueWithIdentifier:@"InvisibilityAnimationSegue" sender:self];
    }
    if ([model.vCStr isEqualToString:@"VisibilityAnimationVC"]) {
        [self performSegueWithIdentifier:@"VisibilityAnimationSegue" sender:self];
    }
    if ([model.vCStr isEqualToString:@"AnimationTimeVC"]) {
        [self performSegueWithIdentifier:@"AnimationTimeSegue" sender:self];
    }
    if ([model.vCStr isEqualToString:@"BufferVC"]) {
        [self performSegueWithIdentifier:@"BufferSegue" sender:self];
    }
    
//    [self.navigationController pushViewController:VC animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"BoardLayerSegue"]) {
        UIViewController *VC = segue.destinationViewController;
        VC.title = @"寄宿层";
    }
    if ([segue.identifier isEqualToString:@"LayerGeometrySegue"]) {
        segue.destinationViewController.title = @"图层几何学";
    }
    if ([segue.identifier isEqualToString:@"VisionEffectionSegue"]) {
        segue.destinationViewController.title = @"视觉效果";
    }
    if ([segue.identifier isEqualToString:@"TransformationSegue"]) {
        segue.destinationViewController.title = @"变换";
    }
    if ([segue.identifier isEqualToString:@"ProprietaryLayerSegue"]) {
        segue.destinationViewController.title = @"专有涂层";
    }
    if ([segue.identifier isEqualToString:@"InvisibilityAnimationSegue"]) {
        segue.destinationViewController.title = @"隐式动画";
    }
    if ([segue.identifier isEqualToString:@"VisibilityAnimationSegue"]) {
        segue.destinationViewController.title = @"显式动画";
    }
    if ([segue.identifier isEqualToString:@"AnimationTimeSegue"]) {
        segue.destinationViewController.title = @"图层时间";
    }
    if ([segue.identifier isEqualToString:@"BufferSegue"]) {
        segue.destinationViewController.title = @"缓冲";
    }
}
+(void)load{
    [super load];
    
}
@end
