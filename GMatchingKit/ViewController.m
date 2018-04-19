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
   
    NSLog(@"KMP:");
    NSDate *start = [NSDate date];
    GMatcherExpression * KMP = [GMatcherExpression matcherExpressionWithPatterns:self.searchKeywords option:GMatchingOption_KMP];
    NSArray * kmps = [KMP matchesInString:self.searchStr];
    NSLog(@"excute time:%f", [[NSDate date] timeIntervalSinceDate:start]);
    
    NSLog(@"Regexs:");
    start = [NSDate date];
    GMatcherExpression * Regex = [GMatcherExpression matcherExpressionWithPatterns:self.searchKeywords option:GMatchingOption_Regex];
    NSArray * Regexs = [Regex matchesInString:self.searchStr];
     __block int count = 0;
    [Regex enumerateMatchesInString:self.searchStr usingBlock:^(GMatcherResult *result, BOOL *stop) {
        count ++;
    }];
    NSLog(@"excute time:%f", [[NSDate date] timeIntervalSinceDate:start]);
    
    NSLog(@"AC:");
    start = [NSDate date];
    GMatcherExpression * AC = [GMatcherExpression matcherExpressionWithPatterns:self.searchKeywords option:GMatchingOption_AC];
    NSArray * ACS = [AC matchesInString:self.searchStr];
    NSLog(@"excute time:%f", [[NSDate date] timeIntervalSinceDate:start]);
 
    NSLog(@"range:");
    start = [NSDate date];
    [self matchAndReplaceCommonKeyWithCommonKeyArray:self.searchKeywords searchString:self.searchStr];
    NSLog(@"excute time:%f", [[NSDate date] timeIntervalSinceDate:start]);
    NSLog(@"kmpcount--%ld; account--%ld; RegexsCount--%ld %ld",kmps.count,ACS.count,Regexs.count,count);
}


- (void)matchAndReplaceCommonKeyWithCommonKeyArray:(NSArray<NSString *> *)commenKeyArray searchString:(NSString*)searchStr
{
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
        } while (1);
    }
}

@end
