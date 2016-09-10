//
//  MaintbaleViewCell.m
//  CoreAnimationDemo
//
//  Created by 杨春至 on 16/9/9.
//  Copyright © 2016年 com.hofon. All rights reserved.
//

#import "MaintbaleViewCell.h"

@interface MaintbaleViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *infoLb;

@end

@implementation MaintbaleViewCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (void)setModel:(MaintableCellModel *)model{
    self.infoLb.text = model.titleStr;
    
    
}
@end
