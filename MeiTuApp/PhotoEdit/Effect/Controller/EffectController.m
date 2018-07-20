//
//  EffectController.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "EffectController.h"
#import "BloomEffect.h"
#import "EffectBase.h"
#import "EffectBaseTool.h"


@interface EffectController ()

@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,strong) EffectBaseTool *effectBaseTool;
@property (nonatomic,strong) EffectBase *selectedEffect;

@end

static NSString *const cellID = @"BaseCellID";

@implementation EffectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithObjects:
                       @"None",
                       @"Spot",
                       @"Hue",
                       @"HighlightShadow",
                       @"Bloom",
                       @"Gloom",
                       @"Posterize",
                       @"Pixellate", nil];
    self.imageView.image = self.showImage;
    self.effectBaseTool = [[EffectBaseTool alloc]initWithImageEditor:self];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseImgAndLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    
    cell.imageView.image = self.thumbImage;
    cell.nameLabel.text = self.dataSource[indexPath.row];
    if ([self.dataSource[indexPath.row] isEqualToString:@"HighlightShadow"]) {
        //TODO:label自适应
        cell.nameLabel.font = [UIFont systemFontOfSize:7];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Class effectClass;
    
    effectClass = NSClassFromString([NSString stringWithFormat:@"%@Effect",self.dataSource[indexPath.row]]);
    if (indexPath.row == 0) {
        effectClass = NSClassFromString(@"EffectBase");
    }
//    if (indexPath.row == 0) {
//        self.imageView.image = self.showImage;
//    }else{
        self.selectedEffect = [[effectClass alloc]initWithSuperView:self.imageView.superview imageViewFrame:self.imageView.frame];
        self.effectBaseTool.selectedEffect = self.selectedEffect;
//    }
}
- (void)setEffectBaseTool:(EffectBaseTool *)effectBaseTool{
    if(effectBaseTool != _effectBaseTool){
        [_effectBaseTool cleanup];
        _effectBaseTool = effectBaseTool;
        [_effectBaseTool setup];

    }
}
- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
}
- (UIImage *)showingImg{
    return self.imageView.image;
}
- (IBAction)saveClick:(id)sender{
    if (self.imageBlock) {
        self.imageBlock(self.imageView.image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.showImage.size, self.bgView.bounds);
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
