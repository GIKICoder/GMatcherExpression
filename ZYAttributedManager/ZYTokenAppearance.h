//
//  ZYTokenAppearance.h
//  GMatchingKit
//
//  Created by GIKI on 2019/10/14.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZYTokenAppearance : NSObject
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *fillColor;
@end

NS_ASSUME_NONNULL_END
