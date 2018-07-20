

//
//  FilterTool.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "FilterTool.h"
#import "LocalizableTool.h"

@implementation FilterTool
+ (NSDictionary*)defaultFilterInfo
{
    NSDictionary *defaultFilterInfo = nil;
    if(defaultFilterInfo==nil){
        defaultFilterInfo =
        @{
          @"CLDefaultEmptyFilter"     : @{@"name":@"CLDefaultEmptyFilter",     @"title":[LocalizableTool localizedString:@"CLDefaultEmptyFilter_DefaultTitle" withDefault:@"None"],       @"version":@(0.0), @"dockedNum":@(0.0)},
          @"CLDefaultLinearFilter"    : @{@"name":@"CISRGBToneCurveToLinear",  @"title":[LocalizableTool localizedString:@"CLDefaultLinearFilter_DefaultTitle" withDefault:@"Linear"],     @"version":@(7.0), @"dockedNum":@(1.0)},
          @"CLDefaultVignetteFilter"  : @{@"name":@"CIVignetteEffect",         @"title":[LocalizableTool localizedString:@"CLDefaultVignetteFilter_DefaultTitle" withDefault:@"Vignette"],   @"version":@(7.0), @"dockedNum":@(2.0)},
          @"CLDefaultInstantFilter"   : @{@"name":@"CIPhotoEffectInstant",     @"title":[LocalizableTool localizedString:@"CLDefaultInstantFilter_DefaultTitle" withDefault:@"Instant"],    @"version":@(7.0), @"dockedNum":@(3.0)},
          @"CLDefaultProcessFilter"   : @{@"name":@"CIPhotoEffectProcess",     @"title":[LocalizableTool localizedString:@"CLDefaultProcessFilter_DefaultTitle" withDefault:@"Process"],    @"version":@(7.0), @"dockedNum":@(4.0)},
          @"CLDefaultTransferFilter"  : @{@"name":@"CIPhotoEffectTransfer",    @"title":[LocalizableTool localizedString:@"CLDefaultTransferFilter_DefaultTitle" withDefault:@"Transfer"],   @"version":@(7.0), @"dockedNum":@(5.0)},
          @"CLDefaultSepiaFilter"     : @{@"name":@"CISepiaTone",              @"title":[LocalizableTool localizedString:@"CLDefaultSepiaFilter_DefaultTitle" withDefault:@"Sepia"],      @"version":@(5.0), @"dockedNum":@(6.0)},
          @"CLDefaultChromeFilter"    : @{@"name":@"CIPhotoEffectChrome",      @"title":[LocalizableTool localizedString:@"CLDefaultChromeFilter_DefaultTitle" withDefault:@"Chrome"],     @"version":@(7.0), @"dockedNum":@(7.0)},
          @"CLDefaultFadeFilter"      : @{@"name":@"CIPhotoEffectFade",        @"title":[LocalizableTool localizedString:@"CLDefaultFadeFilter_DefaultTitle" withDefault:@"Fade"],       @"version":@(7.0), @"dockedNum":@(8.0)},
          @"CLDefaultCurveFilter"     : @{@"name":@"CILinearToSRGBToneCurve",  @"title":[LocalizableTool localizedString:@"CLDefaultCurveFilter_DefaultTitle" withDefault:@"Curve"],      @"version":@(7.0), @"dockedNum":@(9.0)},
          @"CLDefaultTonalFilter"     : @{@"name":@"CIPhotoEffectTonal",       @"title":[LocalizableTool localizedString:@"CLDefaultTonalFilter_DefaultTitle" withDefault:@"Tonal"],      @"version":@(7.0), @"dockedNum":@(10.0)},
          @"CLDefaultNoirFilter"      : @{@"name":@"CIPhotoEffectNoir",        @"title":[LocalizableTool localizedString:@"CLDefaultNoirFilter_DefaultTitle" withDefault:@"Noir"],       @"version":@(7.0), @"dockedNum":@(11.0)},
          @"CLDefaultMonoFilter"      : @{@"name":@"CIPhotoEffectMono",        @"title":[LocalizableTool localizedString:@"CLDefaultMonoFilter_DefaultTitle" withDefault:@"Mono"],       @"version":@(7.0), @"dockedNum":@(12.0)},
          @"CLDefaultInvertFilter"    : @{@"name":@"CIColorInvert",            @"title":[LocalizableTool localizedString:@"CLDefaultInvertFilter_DefaultTitle" withDefault:@"Invert"],     @"version":@(6.0), @"dockedNum":@(13.0)},
          };
    }
    return defaultFilterInfo;
}

+ (id)defaultInfoForKey:(NSString*)key filterName:(NSString *)filterName
{
    
    return self.defaultFilterInfo[[NSString stringWithFormat:@"CLDefault%@Filter",filterName]][key];
}

+ (NSString*)filterName:(NSString *)filterName
{
    return [self defaultInfoForKey:@"name" filterName:filterName];
}

#pragma mark-

+ (NSString*)defaultTitle:(NSString *)filterName
{
    return [self defaultInfoForKey:@"title" filterName:filterName];
}


+ (CGFloat)defaultDockedNumber:(NSString *)filterName
{
    return [[self defaultInfoForKey:@"dockedNum" filterName:filterName] floatValue];
}
+ (UIImage*)applyFilter:(UIImage *)image withFilterName:(NSString*)filterName
{
    return [self filteredImage:image withFilterName:[self filterName:filterName]];
}
+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName
{
    if([filterName isEqualToString:@"CLDefaultEmptyFilter"]){
        return image;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    
    if([filterName isEqualToString:@"CIVignetteEffect"]){
        // parameters for CIVignetteEffect
        CGFloat R = MIN(image.size.width, image.size.height)*image.scale/2;
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width*image.scale/2 Y:image.size.height*image.scale/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:0.9] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    }
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}
@end
