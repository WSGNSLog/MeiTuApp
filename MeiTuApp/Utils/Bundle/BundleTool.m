
//
//  BundleTool.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "BundleTool.h"

@implementation BundleTool
+ (NSBundle *)getPhotoEditorBundle{
    NSBundle *bundle = nil;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PhotoEditor" ofType:@"bundle"];
    if(bundlePath){
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    return bundle;
}
@end
