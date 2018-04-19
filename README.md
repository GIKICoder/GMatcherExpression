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
