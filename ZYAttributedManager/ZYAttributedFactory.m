//
//  ZYAttributedFactory.m
//  GIKI
//
//  Created by GIKI on 2019/10/14.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "ZYAttributedFactory.h"
@implementation ZYAttributedFactory

+ (instancetype)sharedInstance
{
    static ZYAttributedFactory * INST = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INST = [[ZYAttributedFactory alloc] init];
    });
    return INST;
}

- (UIImage *)getEmojiImageName:(NSString *)emojiString
{
    UIImage *image = [UIImage imageNamed:@"Fire_result_pic_happy_select"];
    return image;
}

+ (NSMutableAttributedString*)createAttributedStringWithAttributedConfig:(ZYAttributedConfig*)config
{
    __block NSMutableAttributedString * attributed = [ZYAttributedFactory createBaseAttributedStringWithAttributedConfig:config];
    if (attributed.string.length  <= 0) return nil;
    
    __block NSMutableDictionary *tokenRangesDictM = [NSMutableDictionary dictionary];
    //替换表情
    {
        // 匹配 [表情]
        NSArray<NSTextCheckingResult *> *emoticonResults = [[ZYAttributedFactory regexEmoticon] matchesInString:attributed.string options:kNilOptions range:NSMakeRange(0, attributed.string.length)];
        NSUInteger clipLength = 0;
        
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= clipLength;
            
            if ([attributed yy_attribute:(id)kCTRunDelegateAttributeName atIndex:range.location]) {
                continue;
            }
            NSString *emoString = [attributed.string substringWithRange:range];
            UIImage * emojiImage = [[ZYAttributedFactory sharedInstance] getEmojiImageName:emoString];
            if (!emojiImage) continue;
            NSMutableAttributedString * attr = [ZYAttributedFactory setAttachmentStringWithEmojiImage:emojiImage font:config.font];
            [attributed replaceCharactersInRange:range withAttributedString:attr];
            clipLength += range.length - 1;
        }
    }
    
    /// 字符串匹配
    {
        NSArray * tokens = config.tokenPatternConfigs;
        if (tokens.count > 0) {
            GMatcherExpression * expression = [GMatcherExpression matcherExpressionWithObjectPatterns:tokens option:GMatchingOption_AC];
            NSArray * result = [expression matchesInString:attributed.string];
            
            [result enumerateObjectsUsingBlock:^(GMatcherResult* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.range.location == NSNotFound && obj.range.length <= 1) *stop = NO;
                
                if ([attributed yy_attribute:(NSString*)kCTForegroundColorAttributeName atIndex:obj.range.location]) *stop = NO;
                // 替换的内容
                NSMutableAttributedString *replace = [ZYAttributedFactory setTokenStringWithAttributedToken:obj.info attributedConfig:config];
                if (!replace) *stop = NO;
                // 替换
                [attributed replaceCharactersInRange:obj.range withAttributedString:replace];
            }];
        }
    }
    
    /// 正则匹配
    {
        NSArray * regexs = config.regexPatternConifgs;
        if (regexs.count > 0) {
            NSRange regexRange = NSMakeRange(0,attributed.string.length);
            [regexs enumerateObjectsUsingBlock:^(ZYAttributedToken* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.regexToken && obj.regexToken.length>0) {
                    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:obj.regexToken
                                                                                  options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:attributed.string options:0 range:regexRange];
                    for(NSTextCheckingResult* match in matches.reverseObjectEnumerator) {
                        
                        NSString *matchString = [attributed.string substringWithRange:match.range];
                        if (!matchString || matchString.length == 0) continue;
                        if ([attributed yy_attribute:(NSString*)kCTForegroundColorAttributeName atIndex:match.range.location]) *stop = NO;
                        
                        obj.textToken = matchString;
                        // 替换的内容
                        NSMutableAttributedString *replace = [ZYAttributedFactory setTokenStringWithAttributedToken:obj attributedConfig:config];
                        if (!replace) continue;
                        
                        // 替换
                        [attributed replaceCharactersInRange:match.range withAttributedString:replace];
                        [tokenRangesDictM setObject:obj forKey:NSStringFromRange(match.range)];
                    }
                    
                }
            }];
            
        }
    }
    //    attributed.truncationToken = config.truncationToken;
    return attributed;
}

+ (NSMutableAttributedString*)createBaseAttributedStringWithAttributedConfig:(ZYAttributedConfig*)config
{
    NSMutableString * stringM = config.text.mutableCopy;
    if (!stringM || stringM.length == 0) return nil;
    UIColor *normalColor = config.textColor;
    UIFont *normalFont = config.font;
    
    CTLineBreakMode lineBreakModel = config.lineBreakMode;
    CTTextAlignment textAlignment = config.textAlignment;
    CGFloat linespace = config.linespace;
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)normalFont.fontName,
                                             normalFont.pointSize,
                                             NULL);
    CTParagraphStyleSetting AlignmentStyleSetting;
    AlignmentStyleSetting.spec=kCTParagraphStyleSpecifierAlignment;
    AlignmentStyleSetting.valueSize=sizeof(textAlignment);
    AlignmentStyleSetting.value=&textAlignment;
    
    CTParagraphStyleSetting LineSpacingStyleSetting;
    LineSpacingStyleSetting.spec=kCTParagraphStyleSpecifierLineSpacingAdjustment;// kCTParagraphStyleSpecifierLineSpacing;
    LineSpacingStyleSetting.valueSize=sizeof(linespace);
    LineSpacingStyleSetting.value=&linespace;
    
    CTParagraphStyleSetting LineBreakStyleSetting;
    LineBreakStyleSetting.spec=kCTParagraphStyleSpecifierLineBreakMode;
    LineBreakStyleSetting.valueSize=sizeof(lineBreakModel);
    LineBreakStyleSetting.value=&lineBreakModel;
    
    //首行缩进
    CGFloat fristlineindent = config.font.pointSize*config.lineIndent;
    CTParagraphStyleSetting fristline;
    fristline.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristline.value = &fristlineindent;
    fristline.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting paragraphs[4] = {AlignmentStyleSetting,LineSpacingStyleSetting,LineBreakStyleSetting,fristline};
    
    CTParagraphStyleRef styleRef = CTParagraphStyleCreate(paragraphs, 4);
    
    NSMutableDictionary * attributedConfig = [NSMutableDictionary dictionary];
    [attributedConfig setObject:(__bridge id)fontRef forKey:(__bridge NSString*)kCTFontAttributeName];
    [attributedConfig setObject:(__bridge id)normalColor.CGColor forKey:(__bridge NSString*)kCTForegroundColorAttributeName];
    [attributedConfig setObject:(__bridge id)styleRef forKey:(__bridge NSString*)kCTParagraphStyleAttributeName];
    
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:stringM attributes:attributedConfig.copy];
    
    CFRelease(styleRef);
    CFRelease(fontRef);
    
    return attributed;
}

+ (CGFloat)getRichLabelHeightWithAttributedString:(NSAttributedString*)string MaxContianerWidth:(CGFloat)width
{
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
    return ceilf(size.height+0.5);
}

+ (CGSize)getRichLabelDrawSizeWithAttributedString:(NSAttributedString*)string MaxContianerWidth:(CGFloat)width
{
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
    return size;
}

+ (NSRegularExpression *)regexEmoticon
{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSMutableAttributedString *)setAttachmentStringWithEmojiImage:(UIImage *)image
                                                                font:(UIFont*)font
{
    CGFloat fontSize = font.pointSize;
    if (!image || fontSize <= 0) return nil;
    
    CGFloat ascent = fontSize; //YYEmojiGetAscentWithFontSize(fontSize);
    CGFloat descent = 0; //YYEmojiGetDescentWithFontSize(fontSize);
    CGRect bounding = CGRectMake(0, 0, 20, 20); //YYEmojiGetGlyphBoundingRectWithFontSize(fontSize);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width + 2 * bounding.origin.x;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), bounding.origin.x, descent + bounding.origin.y, bounding.origin.x);
    attachment.content = image;
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr yy_setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

+ (NSMutableAttributedString*)setTokenStringWithAttributedToken:(ZYAttributedToken*)token attributedConfig:(ZYAttributedConfig*)config
{
    if (!token || (token.textToken.length == 0)) return nil;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:token.textToken];
    UIColor * tokenColor= config.tokenTextColor;
    if (token.tokenColor) {
        tokenColor = tokenColor;
    }
    if (!tokenColor) {
        tokenColor = config.textColor;
    }
    [string yy_setAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)tokenColor.CGColor range:NSMakeRange(0, string.length)];
    
    UIFont *tokenFont = token.tokenFont;
    if (!tokenFont) {
        tokenFont = config.font;
    }
    [string yy_setAttribute:(NSString*)kCTFontAttributeName value:(id)tokenFont range:NSMakeRange(0, string.length)];
    // 高亮状态
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = token.tokenAppearance.fillColor;
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setBackgroundBorder:highlightBorder];
    [string yy_setTextHighlight:highlight range:NSMakeRange(0, string.length)];
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (token.tokenActionBlock) {
            token.tokenActionBlock(token);
        }
    };
    return string;
}
@end
