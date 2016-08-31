//
//  Colors.m
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/31/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+ (UIColor *)navigationBarColor{
    return [Colors aytoRedColor];
}

+ (UIColor *)navigationBarTitleColor{
    return [Colors aytoLightTextColor];
}

+ (UIColor *)borderColor{
    return [Colors aytoRedColor];
}

+ (UIColor *)lightBackgroundColor{
    return [Colors aytoLightGrayColor];
}

#pragma mark - Brand Colors
+ (UIColor *)aytoRedColor{
    return [UIColor colorWithRed:165/255.0 green:29/255.0 blue:51/255.0 alpha:1];
}

+ (UIColor *)aytoLightTextColor{
    return [UIColor whiteColor];
}

+ (UIColor *)aytoLightGrayColor{
    return [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
}

@end
