//
//  YMThemeManager.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/6/11.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMThemeManager.h"
#import "YMDeviceHelper.h"
#import "TKWeChatPluginConfig.h"

static const NSString *DEVICE_FINGERPRINT = @"DEVICE_FINGERPRINT";
static const NSString *DEVICE_THEME_MODE = @"DEVICE_THEME_MODE";

@interface YMThemeManager()
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, copy) NSString *fingerprint;
@end

@implementation YMThemeManager
+ (instancetype)shareInstance
{
    static id share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (void)initializeModelConfig
{
    if (!self.fingerprint) {
        self.fingerprint = [YMDeviceHelper deviceFingerprint];
    }
    
    NSDictionary *deviceFingerprint = @{
        DEVICE_FINGERPRINT : self.fingerprint,
        DEVICE_FINGERPRINT : [self _modelValue]
    };
    
}

- (NSString *)_modelValue
{
    if ([TKWeChatPluginConfig sharedConfig].darkMode) {
        return @"1";
    } else if ([TKWeChatPluginConfig sharedConfig].pinkMode) {
        return @"2";
    }
    return @"0";
}

- (void)changeTheme:(NSView *)view
{
    [self changeTheme:view color:kMainBackgroundColor];
}

- (void)checkSubviewsOf:(NSView *)view
{
    // fixe scroller
    for (NSView* subview in [view subviews]) {
        if ([subview.className isEqualToString:@"RFOverlayScroller"]) {
            [self changeTheme:subview color:kMainScrollerColor];
        }
        [self checkSubviewsOf:subview];
    }
}

- (void)changeTheme:(NSView *)view color:(NSColor *)color
{
    // ignore pined image
    if (view.tag == 9999999) {
        return;
    }
    if (TKWeChatPluginConfig.sharedConfig.usingDarkTheme) {
        // fix scroller
        [self checkSubviewsOf:view];
    }
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:color.CGColor];
    [view setWantsLayer:YES];
    [view setNeedsDisplay:YES];
    [view setLayer:viewLayer];
}

- (NSColor *)randomColor:(NSString *)string
{
    if (string.length == 0) {
        return [NSColor whiteColor];
    }
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:0 error:nil];
    string = [regularExpression stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
    NSString *subString =  [string substringToIndex:4];
    int index = subString.intValue % self.colors.count;
    
    if (index < self.colors.count) {
        return self.colors[index];
    }
    
    return [NSColor whiteColor];
}

- (NSArray *)colors
{
    return @[
        kRGBColor(205, 128, 122, 1.0),
        kRGBColor(128, 164, 248, 1.0),
        kRGBColor(254, 201, 121, 1.0),
        kRGBColor(224, 132, 159, 1.0),
        kRGBColor(191, 121, 116, 1.0),
        kRGBColor(157, 137, 213, 1.0),
        kRGBColor(242, 171, 65, 1.0),
        kRGBColor(80, 102, 246, 1.0),
        kRGBColor(75, 167, 238, 1.0),
        kRGBColor(69, 125, 51, 1.0),
        kRGBColor(191, 121, 116, 1.0),
        kRGBColor(157, 137, 213, 1.0),
        kRGBColor(156, 44, 103, 1.0),
        kRGBColor(193, 105, 39, 1.0),
        kRGBColor(248, 193, 155, 1.0),
        kRGBColor(240, 121, 152, 1.0),
        kRGBColor(63, 131, 203, 1.0),
        kRGBColor(138, 51, 123, 1.0),
        kRGBColor(253, 124, 123, 1.0),
        kRGBColor(254, 201, 121, 1.0),
        kRGBColor(224, 132, 159, 1.0),
        kRGBColor(248, 193, 155, 1.0),
        kRGBColor(240, 121, 152, 1.0),
        kRGBColor(154, 205, 50, 1.0),
        kRGBColor(205, 133, 0, 1.0),
        kRGBColor(82, 139, 139, 1.0),
        kRGBColor(248, 193, 155, 1.0),
    ];
}

+ (void)changeButtonTheme:(NSButton *)button
{
    if (![TKWeChatPluginConfig sharedConfig].usingDarkTheme) {
        return;
    }
    
    NSMutableAttributedString *returnValue = [[NSMutableAttributedString alloc] initWithString:button.title attributes:@{NSForegroundColorAttributeName :[NSColor whiteColor]}];
    button.attributedTitle = returnValue;
}
@end
