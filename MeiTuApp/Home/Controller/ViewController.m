//
//  ViewController.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/18.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FunctionOptionCell.h"
#import "BundleTool.h"
#import "FilterController.h"
#import "EffectController.h"
#import "BlurFocusController.h"
#import "AjustController.h"

#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 60
#define ItemWidth 60
#define ItemHeight 60

static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageV;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) PHCachingImageManager *imageManager;
@property (strong,nonatomic) UIImage *thumbImg;

@end

static NSString *const cellID = @"FuncOptionCell";

@implementation ViewController
- (PHCachingImageManager *)imageManager{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    return _imageManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource =[NSMutableArray arrayWithObjects:@"Filter",@"Adjustment",@"Effect",@"Blur",@"Rotate",@"Draw",@"Splash",@"Crop",@"Resize",@"ToneCurve",@"Emotion",@"Sticker",@"Text", nil];
    [self initBottomView];
    
    NSBundle *bundle = [BundleTool getPhotoEditorBundle];
    
    NSString *path = [bundle pathForResource:@"defaultShow.jpg" ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    self.photoImageV.image = img;
    self.thumbImg = [UIImage imageWithData:UIImageJPEGRepresentation(img, 0.3)];
    
}

- (IBAction)openAlbum:(UIButton *)sender {
    
    UIImagePickerController *pickVC = [[UIImagePickerController alloc]init];
    pickVC.delegate = self;
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickVC animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSURL *imgUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHAsset *asset = [[PHAsset fetchAssetsWithALAssetURLs:@[imgUrl] options:nil] firstObject];
        
        self.photoImageV.image = image;
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeScale(CGSizeMake(ItemWidth-15, ItemWidth-15),[[UIScreen mainScreen] scale]) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.thumbImg = result;
        }];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"点击了取消按钮");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)initBottomView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, CollectionHeight) collectionViewLayout:flowLayout];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FunctionOptionCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
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
    
    FunctionOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"CL%@Tool_icon",self.dataSource[indexPath.row]];
    cell.funcImgView.image = [UIImage imageNamed:imageName];
    cell.funcNameLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0:
        {
            FilterController *filter = [[FilterController alloc]init];
            filter.showImage = self.photoImageV.image;
            filter.thumbImage = self.thumbImg;
            filter.imageBlock = ^(UIImage *image) {
                weakSelf.photoImageV.image = image;
            };
            [self presentViewController:filter animated:YES completion:nil];
        }
            break;
        case 1:
        {
            AjustController *ajust = [[AjustController alloc]init];
            ajust.showImage = self.photoImageV.image;
            
            ajust.imageBlock = ^(UIImage *image) {
                weakSelf.photoImageV.image = image;
            };
            [self presentViewController:ajust animated:YES completion:nil];
        }
            break;
        case 2:
        {
            EffectController *effect = [[EffectController alloc]init];
            effect.showImage = self.photoImageV.image;
            effect.thumbImage = self.thumbImg;
            effect.imageBlock = ^(UIImage *image) {
                weakSelf.photoImageV.image = image;
            };
            [self presentViewController:effect animated:YES completion:nil];
        }
            break;
        case 3:
        {
            BlurFocusController *blur = [[BlurFocusController alloc]init];
            blur.showImage = self.photoImageV.image;
            blur.imageBlock = ^(UIImage *image) {
                weakSelf.photoImageV.image = image;
            };
            [self presentViewController:blur animated:YES completion:nil];
        }
            break;
        case 4:
        {}
            break;
        case 5:
        {}
            break;
        case 6:
        {}
            break;
        case 7:
        {}
            break;
        case 8:
        {}
            break;
        case 9:
        {}
            break;
        case 10:
        {}
            break;
        case 11:
        {}
            break;
        case 12:
        {}
            break;
        default:
            break;
    }
}
- (IBAction)saveClick:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.photoImageV.image, nil, nil, nil);
}

@end
