//
//  BaseController.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "BaseController.h"

#import "LocalizableTool.h"
#import "FilterTool.h"

#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 60
#define ItemWidth 60
#define ItemHeight 60

@interface BaseController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

static NSString *const cellID = @"BaseCellID";

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithObjects:@"Empty",@"Linear",@"Vignette",@"Instant",@"Process",@"Transfer",@"Sepia",@"Chrome",@"Fade",@"Curve",@"Tonal",@"Noir",@"Mono",@"Invert", nil];
    
    [self initBottomView];
}
- (void)initBottomView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, CollectionHeight) collectionViewLayout:flowLayout];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BaseImgAndLabelCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
    [self.optionView addSubview:collectionView];
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(ItemWidth, ItemHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, CellMargin, 0, CellMargin);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseImgAndLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    //NSString *imageName = [NSString stringWithFormat:@"CL%@Tool_icon",self.dataSource[indexPath.row]];
    cell.imageView.image = [FilterTool applyFilter:self.thumbImage withFilterName:self.dataSource[indexPath.row]];
    NSString *localizableKey = [NSString stringWithFormat:@"CLDefault%@Filter_DefaultTitle",self.dataSource[indexPath.row]];
    NSString *localizableStr = [LocalizableTool localizedString:localizableKey withDefault:self.dataSource[indexPath.row]];
    cell.nameLabel.text = localizableStr;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveClick:(id)sender {
    
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
