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
 
    NSLog(@"range:");
    start = [NSDate date];
    NSArray * ranges = [self matchAndReplaceCommonKeyWithCommonKeyArray:self.searchKeywords searchString:self.searchStr];
    NSLog(@"excute time:%f", [[NSDate date] timeIntervalSinceDate:start]);
    NSLog(@"kmpcount--%ld; account--%ld;ranges--%ld",kmps.count,ACS.count,ranges.count);
}


- (NSArray*)matchAndReplaceCommonKeyWithCommonKeyArray:(NSArray<NSString *> *)commenKeyArray searchString:(NSString*)searchStr
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSString *child in commenKeyArray) {
        if (child.length == 0) continue;
        NSRange searchRange = NSMakeRange(0, searchStr.length);
        NSRange range;
        do {
            range = [searchStr rangeOfString:child options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;
            
            searchRange.location = searchRange.location + (range.length ? range.length : 1);
            if (searchRange.location + 1>= searchStr.length) break;
            searchRange.length = searchStr.length - searchRange.location;
            [array addObject:[NSValue valueWithRange:range]];
        } while (1);
    }
    return array.copy;
}

@end
