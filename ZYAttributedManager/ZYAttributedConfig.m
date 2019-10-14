//
//  ZYAttributedConfig.m
//  GIKI
//
//  Created by GIKI on 2019/10/14.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "ZYAttributedConfig.h"

@implementation ZYAttributedConfig
+ (instancetype)attributedConfig:(NSString*)text
{
    return [ZYAttributedConfig attributedConfig:text color:nil font:nil];
}

+ (instancetype)attributedConfig:(NSString*)text color:(UIColor*)color font:(UIFont*)font
{
    ZYAttributedConfig *defalut = [[ZYAttributedConfig alloc] init];
    if (text) defalut.text = text;
    if (color) defalut.textColor = color;
    if (font)  defalut.font = font;
    return defalut;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = [UIColor blackColor];
        self.tokenTextColor = [UIColor blueColor];
        self.font = [UIFont systemFontOfSize:14];
        self.linespace = 0;
        self.lineBreakMode = kCTLineBreakByWordWrapping;
        self.textAlignment = kCTLineBreakByWordWrapping;
        //        self.numberOfLines = 1;
        self.lineIndent = 0;
    }
    return self;
}
@end
