//
//  ZYAttributedFactory.h
//  GIKI
//
//  Created by GIKI on 2019/10/14.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYAttributedConfig.h"
#import "YYText.h"
#import "GMatcherExpression.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYAttributedFactory : NSObject

+ (instancetype)sharedInstance;
+ (NSMutableAttributedString*)createAttributedStringWithAttributedConfig:(ZYAttributedConfig*)config;
@end

NS_ASSUME_NONNULL_END
