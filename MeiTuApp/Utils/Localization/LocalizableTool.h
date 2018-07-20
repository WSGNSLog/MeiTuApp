//
//  LocalizableToll.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/18.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizableTool : NSObject
+ (NSString*)localizedString:(NSString*)key withDefault:defaultValue;
@end
