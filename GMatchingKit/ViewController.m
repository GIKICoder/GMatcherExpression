//
//  ViewController.m
//  GMatchingKit
//
//  Created by GIKI on 2018/4/17.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "ViewController.h"
#import "GKMPMatcherProcessor.h"
#import "GACMatcherProcessor.h"
#import "GMatcherExpression.h"
#import "SearchStringTest.h"
#import "GKMPMatcherProcessor.h"
@interface ViewController ()
@property (nonatomic, strong) NSString  * searchStr;
@property (nonatomic, strong) NSArray * searchKeywords;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchStr = [SearchStringTest getSearchString];
    self.searchKeywords = [SearchStringTest get10Words];
    [self testKMP];
}

- (void)testKMP
{
    
//    self.searchKeywords = @[@"牛逼",@"屌丝",@"程序员"];
//    self.searchStr = @"xx是一个牛逼的屌丝程序员";
    NSLog(@"KMP:");
    NSDate *start = [NSDate date];
    GMatcherExpression * KMP = [GMatcherExpression matcherExpressionWithPatterns:self.searchKeywords option:GMatchingOption_KMP];
    NSArray * kmps = [KMP matchesInString:self.searchStr];
    NSLog(@"excute time:%f", [[NSDate date] timeIntervalSinceDate:start]);
    
    
    NSLog(@"AC:");
    start = [NSDate date];
    GMatcherExpression * AC = [GMatcherExpression matcherExpressionWithPatterns:self.searchKeywords option:GMatchingOption_AC];
    NSArray * ACS = [AC matchesInString:self.searchStr];
    NSLog(@"excute time:%f", [[NSDate date] timeIntervalSinceDate:start]);
    
    NSLog(@"kmpcount--%ld; account--%ld;",kmps.count,ACS.count);
}


@end
