//
//  ZYRichLabelController.m
//  YYTextDemo
//
//  Created by GIKI on 2019/10/14.
//  Copyright © 2019 ibireme. All rights reserved.
//

#import "ZYRichLabelController.h"
#import "YYText.h"
#import "ZYAttributedFactory.h"

#define kPhone @"(([0-9]{11})|((400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?)|(110|120|119|114))"
@interface ZYRichLabelController ()
@property (nonatomic, strong) YYLabel * label;
@property (nonatomic, strong) NSArray * tokens;
@end

@implementation ZYRichLabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button setTitle:@"退出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 10, 100, 100);
    [self.view addSubview:button];
    
    self.label = [YYLabel new];
    [self.view addSubview:self.label];
    self.label.numberOfLines = 0;
    self.label.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-200);
    self.label.backgroundColor = UIColor.redColor;
    self.tokens = @[@"@张三",@"@李四",@"@巩柯",@"#王五#",@"杨成虎的百科:"];
    [self setRichText];
}

- (void)buttonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setRichText
{
    __weak typeof(self) ws = self;
    NSString* string =[self content];
    __block NSMutableArray *tokens = [NSMutableArray array];
    [self.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj) *stop = NO;
        ZYAttributedToken * token = [ZYAttributedToken attributedTextToken:obj];
        token.tokenActionBlock = ^(ZYAttributedToken *token) {
            NSLog(@"token Click ~%@",token.textToken);
        };
        [tokens addObject:token];
    }];
    ZYAttributedToken *regex = [ZYAttributedToken new];
    regex.regexToken = kPhone;
    regex.tokenActionBlock = ^(ZYAttributedToken *token) {
        NSLog(@"token Click ~%@",token.textToken);
    };
    ZYAttributedConfig *attributedConfig = [ZYAttributedConfig attributedConfig:string];
    attributedConfig.tokenPatternConfigs = tokens.copy;
    attributedConfig.regexPatternConifgs = @[regex];
    attributedConfig.textAlignment = kCTTextAlignmentJustified;
    attributedConfig.linespace = 4;
    attributedConfig.lineIndent = 2;
    attributedConfig.font = [UIFont systemFontOfSize:14];
    
    NSMutableAttributedString * truncation = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
    [truncation yy_setAttribute:(NSString*)kCTFontAttributeName value:(id)([UIFont systemFontOfSize:14]) range:NSMakeRange(0, truncation.length)];
    [truncation yy_setAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blueColor] range:NSMakeRange(3, 2)];
    attributedConfig.truncationToken = truncation;
    
    NSAttributedString *attri = [ZYAttributedFactory createAttributedStringWithAttributedConfig:attributedConfig];
    self.label.attributedText = attri;
    
}


- (NSString *)content
{
    return  @"杨成虎的百科:aa 11🐶[干杯]🐶春天在哪里，🐶[哭笑不得]🐶春/n天@在你的眼睛里，oh, myaa god, @张三:18900126257 @李四 @巩柯 #王五# 春天在他的眼 [干杯]aa 睛里，春天在你aa我的眼睛里你的两岸观光进入寒冬，陆客赴bb台人数持续缩减。据台湾《经济日报》23日报道，民\n党当局转向冲刺“新南向”的bb客源，[哭笑不得]锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年de我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆@张三 @李四客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期大减四成。“交通部”官员预估，我今年我陆客来台人数将比去年减少100万人次，台湾将减少4[哭笑不得]26.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交流盛会也决定不来，“台湾观光协我会在两岸民间交流我中扮我演的地位，可谓一落千丈”。该报我介绍我称台湾，“台湾观光协会”是由岛内航空公司、观光饭店、@张三 @李四旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任我，《经济日我报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交我流盛会也决定不来，“台湾观光协会在两岸民间交流中扮演的我地位，可谓一落千丈”。该报介绍称，“台湾观光我协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任，陈水扁当政时期，“观光协会”在两岸观光交流中扮演桥梁角色，马英九开放陆客来台观光后，该协会更成为两岸观光交流位阶最高的民间单位，尤其赖瑟珍担任会长时，多次率领岛内业者赴大陆参访、交流，为两岸观光建立极佳交情我。不过叶菊兰接掌“观光协会”后，虽然表示欢迎陆客来台，但强调不愿意持台胞证赴大陆，让对岸担忧其政治立场。与此同时，叶菊兰虽然表态要委任赖瑟珍继续奔走两岸，但迄今没落实，“形同放弃与陆方打交道、建立关系的机会”。11春天在哪里，春天在你的眼睛里，oh, my god, 春天在他的眼睛里，春天在你我的眼睛里你的两岸观光进入寒冬，陆客赴台人数持续缩减。据台湾《经济日报》23日报道，民进党当局转向冲刺“新南向”的客源，锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者直言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期大减四成。“交通部”官员预估，我今年我陆客来台人数将比去年减少100万人次，台湾将减少426.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，来台人数将比去年减少100万人次，台湾将减少426.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交流盛会也决定不来，“台湾观光协我会在两岸民间交流我中扮我演的地位，可谓一落千丈”。该报我介绍我称，“台湾观光协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任我，《经济日我报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交我流盛会也决定不来，“台湾观光协会在两岸民间交流中扮演的我地位，可谓一落千丈”。该报介绍称，“台湾观光我协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任，陈水扁当政时期，“观光协会”在两岸观光交流中扮演桥梁角色，马英九开放陆客来台观光后，该协会更成为两岸观光交流位阶最高的民间单位，尤其赖瑟珍担任会长时，多次率领岛内业者赴大陆参访、交流，为两岸观光建立极佳交情我。不过叶菊兰接掌“观光协会”后，虽然表示欢迎陆客来台，但强调不愿意持台胞证赴大陆，让对岸担忧其政治立场。与此同时，叶菊兰虽然表态要委任赖瑟珍继续奔走两岸，但迄今没落实，“形同放弃与陆方打交道、建立关系的机会”。11春天在哪里，春天在你的眼睛里，oh, my god, 春天在他的眼睛里，春天在你我的眼睛里你的两岸观光进入寒冬，陆客赴台人数持续缩减。据台湾《经济日报》23日报道，民进党当局转向冲刺“新南向”的客源，锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者直言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期.............................，，";
}
@end
