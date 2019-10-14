//
//  ZYAttributedToken.m
//  GIKI
//
//  Created by GIKI on 2019/10/14.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "ZYAttributedToken.h"
#import "ZYTokenAppearance.h"
@implementation ZYAttributedToken
+ (instancetype)attributedTextToken:(NSString*)textToken
{
    return [ZYAttributedToken attributedTextToken:textToken color:nil font:nil];
}

+ (instancetype)attributedTextToken:(NSString*)textToken color:(UIColor*)color
{
    return [ZYAttributedToken attributedTextToken:textToken color:color font:nil];
}

+ (instancetype)attributedTextToken:(NSString*)textToken color:(UIColor*)color font:(UIFont*)font
{
    ZYAttributedToken * token = [ZYAttributedToken new];
    token.textToken = textToken;
    token.tokenColor = color;
    token.tokenFont = font;
    ZYTokenAppearance * appearance = [ZYTokenAppearance new];
    appearance.cornerRadius = 4;
    appearance.fillColor = [UIColor colorWithRed:69/255.0 green:111/255.0 blue:238/255.0 alpha:0.6];
    token.tokenAppearance =  appearance;
    return token;
}

+ (instancetype)attributedRegexToken:(NSString*)regexToken
{
    return [ZYAttributedToken attributedRegexToken:regexToken color:nil font:nil];
}

+ (instancetype)attributedRegexToken:(NSString*)regexToken color:(UIColor*)color
{
    return [ZYAttributedToken attributedRegexToken:regexToken color:color font:nil];
}

+ (instancetype)attributedRegexToken:(NSString*)regexToken color:(UIColor*)color font:(UIFont*)font
{
    ZYAttributedToken * token = [ZYAttributedToken new];
    token.regexToken = regexToken;
    token.tokenColor = color;
    token.tokenFont = font;
    ZYTokenAppearance * appearance = [ZYTokenAppearance new];
    appearance.cornerRadius = 4;
    appearance.fillColor = [UIColor colorWithRed:58/255 green:59/255 blue:205/255 alpha:0.6];
    token.tokenAppearance =  appearance;
    return token;
}

#pragma mark - protocol Method
- (NSString *)getPatternString
{
    return self.textToken;
}
@end
