#line 1 "/Users/stephen/Jailbreak/BubbleHue/BubbleHue/BubbleHue.xm"














#import "UIImage+ImageColoring.h"
#import "UIImage+Tint.h"
#import <UIKit/UIKit.h>

#define PreferencesChangedNotification "stephensilber.BubbleHue-preferencesChanged"
#define PreferencesFilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/stephensilber.BubbleHue.plist"]

#define TMred   0.4823529
#define TMgreen 0.9294118
#define TMblue  0.3882353











static float greenBubblePresets[6]  = { nil, 180.0f, 0, 240.0f, 70.0f, 190.0f };
static float blueBubblePresets[6]   = { nil, 130.0f, 0.0f, 250.0f, 75.0f, 190.0f };
static float redBubblePresets[6]    = { nil, 360.0f, 225.0f, 125.0f, 265.0f, 30.0f };

static NSDictionary *preferences = nil;

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [preferences release];
    preferences = [[NSDictionary alloc] initWithContentsOfFile:PreferencesFilePath];
}
@interface UIDeviceRGBColor : UIColor {
    float redComponent;
    float greenComponent;
    float blueComponent;
}
@end


#include <logos/logos.h>
#include <substrate.h>
@class CKGradientView; 
static id (*_logos_orig$_ungrouped$CKGradientView$gradient)(CKGradientView*, SEL); static id _logos_method$_ungrouped$CKGradientView$gradient(CKGradientView*, SEL); 

#line 54 "/Users/stephen/Jailbreak/BubbleHue/BubbleHue/BubbleHue.xm"



static id _logos_method$_ungrouped$CKGradientView$gradient(CKGradientView* self, SEL _cmd) {
    BOOL isSMS = NO;
    BOOL isUniversal = NO;
    
    
    if(_logos_orig$_ungrouped$CKGradientView$gradient(self, _cmd)) {
        UIImage *color = _logos_orig$_ungrouped$CKGradientView$gradient(self, _cmd);
        CGFloat hue     = 0.0f;
        CGFloat sat     = 0.0f;
        
        if([[preferences objectForKey:@"gradientEnabled"] integerValue] == 1) {
            isUniversal = YES;
            color = [color imageTintedWithColor:[UIColor redColor]];
        }
        
        
        for(UIDeviceRGBColor *colorString in [self colors]) {
            const CGFloat* components = CGColorGetComponents(colorString.CGColor);
            float redBalloon = floorf(components[0] * 100) / 100;
            float greenBalloon = floorf(components[1] * 100) / 100;
            float blueBalloon = floorf(components[2] * 100) / 100;
            float redTM = floorf(TMred * 100) / 100;
            float greenTM = floorf(TMgreen * 100) / 100;
            float blueTM = floorf(TMblue * 100) / 100;
            
            if(redTM == redBalloon && greenTM == greenBalloon && blueBalloon == blueTM) {
                isSMS = YES;
                break;
            }
        }
        
        
        if(!isSMS) {
            if ([[preferences objectForKey:@"customValueSwitchiMsg"] integerValue] == 1) {
                hue = [[preferences objectForKey:@"hueSliderValueiMsg"] floatValue];
                sat = [[preferences objectForKey:@"satSliderValueiMsg"] floatValue];
            } else {
                NSInteger colorIndexPath = [[preferences objectForKey:@"presetListiMsg"] integerValue];
                hue = (isUniversal) ? redBubblePresets[colorIndexPath] : blueBubblePresets[colorIndexPath];
            }
            
            
        } else {
            if ([[preferences objectForKey:@"customValueSwitchTxt"] integerValue] == 1) {
                hue = [[preferences objectForKey:@"hueSliderValueTxt"] floatValue];
                sat = [[preferences objectForKey:@"satSliderValueTxt"] floatValue];
            } else {
                NSInteger colorIndexPath = [[preferences objectForKey:@"presetListTxt"] integerValue];
                hue = (isUniversal) ? redBubblePresets[colorIndexPath] : greenBubblePresets[colorIndexPath];
            }
        }
        
        
        return [color imageByAdjustingHue:hue saturation:sat lightness:0.0f];
        
    } else {
        return _logos_orig$_ungrouped$CKGradientView$gradient(self, _cmd);
    }
}



__attribute__((constructor)) static void internalizer_init() {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    preferences = [[NSDictionary alloc] initWithContentsOfFile:PreferencesFilePath];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesChangedCallback, CFSTR(PreferencesChangedNotification), NULL, CFNotificationSuspensionBehaviorCoalesce);
    
    [pool release];
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$CKGradientView = objc_getClass("CKGradientView"); MSHookMessageEx(_logos_class$_ungrouped$CKGradientView, @selector(gradient), (IMP)&_logos_method$_ungrouped$CKGradientView$gradient, (IMP*)&_logos_orig$_ungrouped$CKGradientView$gradient);} }
#line 127 "/Users/stephen/Jailbreak/BubbleHue/BubbleHue/BubbleHue.xm"
