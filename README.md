# GMatcherExpression
包含KMP匹配 ,AC 多模字符串匹配.
```objc
self.searchKeywords = @[@"牛逼",@"屌丝",@"程序员"];
self.searchStr = @"xx是一个牛逼的屌丝程序员";

输出:
{5, 2},牛逼
{8, 2},屌丝
{10, 3},程序员
```

```objc
/// KMP 匹配
GMatcherExpression * KMP = [GMatcherExpression matcherExpressionWithPatterns:self.searchKeywords option:GMatchingOption_KMP];
NSArray * kmps = [KMP matchesInString:self.searchStr];

```

```objc
/// AC 多模匹配
GMatcherExpression * AC = [GMatcherExpression matcherExpressionWithPatterns:self.searchKeywords option:GMatchingOption_AC];
NSArray * ACS = [AC matchesInString:self.searchStr];

```
```objc
/// 均支持block 回调
[AC enumerateMatchesInString:self.searchStr usingBlock:^(GMatcherResult *result, BOOL *stop) {

}];
```

```objc
/// oc传统字符串匹配
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
[array addObject:[NSValue valueWithRange:searchRange]];
} while (1);
}
return array.copy;
}
```
```
匹配效率对比（ms）：
KMP:
excute time:0.202863
AC:
excute time:0.008575
range:
excute time:8.845589
```
