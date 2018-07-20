//
//  BaseController.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseImgAndLabelCell.h"

@interface BaseController : UIViewController
@property (strong,nonatomic) UIImage *showImage;
@property (strong,nonatomic) UIImage *thumbImage;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *dataSource;

@property (nonatomic,strong,readonly) UIImage *showingImg;


@property (copy,nonatomic) void(^imageBlock)(UIImage *image);
- (IBAction)saveClick:(id)sender;
- (IBAction)cancelClick:(id)sender;

- (void)setImage:(UIImage *)image;
@end
