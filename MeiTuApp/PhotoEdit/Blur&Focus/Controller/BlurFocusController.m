//
//  BlurFocusController.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "BlurFocusController.h"
#import "BlurTool.h"

@interface BlurFocusController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (strong,nonatomic) BlurTool *blurTool;

@end
static NSString *const cellID = @"BaseCellID";
@implementation BlurFocusController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithObjects:@"normal",@"circle",@"band", nil];
    self.imageView.image = self.showImage;
    self.blurTool = [[BlurTool alloc]initWithImageEditor:self];
    [self.blurTool setup];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseImgAndLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    
    cell.imageView.image = self.thumbImage;
    cell.nameLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (indexPath.row == 0) {
        self.imageView.image = self.showImage;
    }else{
        [self.blurTool didSelectedMenuAtIndex:(int)indexPath.row];
    }
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
