/*
 BubbleHue -- An open source tweak that changes the hue of the chat bubbles in Messages.app
 Currently -- Adjusts all images (no distinction between iMessage and textMessage)
 Ideas to fix this:
 * get average color and distinguish green vs blue (computationally heavy)
 * hook into CKIMMessage
 * @property(readonly, nonatomic) BOOL isSMS;
 * @property(readonly, nonatomic) BOOL isiMessage;
 * Not sure how to access this from Chat bubbles yet.
 
 Author: Stephen Silber
 iOS: 7.0+
 */

#import "UIImage+ImageColoring.h"
#import "UIImage+Tint.h"
#import <UIKit/UIKit.h>

#define PreferencesChangedNotification "stephensilber.BubbleHue-preferencesChanged"
#define PreferencesFilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/stephensilber.BubbleHue.plist"]

/* Hack solution to determine the type of bubble we are tinting */
#define TMred   0.4823529
#define TMgreen 0.9294118
#define TMblue  0.3882353

/* 
 Preset Colors:
 0: None
 1: Red
 2: Blue
 3: Green
 4: Purple
 5: Orange
*/

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


%hook CKGradientView

// I'll replace each color with a shifted hue. Color class
- (id) gradient {
    BOOL isSMS = NO;
    BOOL isUniversal = NO;
    
    // We have a colored bubble --> Lets check the settings and apply transformations
    if(%orig) {
        UIImage *color = %orig;
        CGFloat hue     = 0.0f;
        CGFloat sat     = 0.0f;
        
        if([[preferences objectForKey:@"gradientEnabled"] integerValue] == 1) {
            isUniversal = YES;
            color = [color imageTintedWithColor:[UIColor redColor]];
        }
        
        /* Compare colors to check if the bubble is iMessage or Text Message */
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
        
        // iMessage
        if(!isSMS) {
            if ([[preferences objectForKey:@"customValueSwitchiMsg"] integerValue] == 1) {
                hue = [[preferences objectForKey:@"hueSliderValueiMsg"] floatValue];
                sat = [[preferences objectForKey:@"satSliderValueiMsg"] floatValue];
            } else {
                NSInteger colorIndexPath = [[preferences objectForKey:@"presetListiMsg"] integerValue];
                hue = (isUniversal) ? redBubblePresets[colorIndexPath] : blueBubblePresets[colorIndexPath];
            }
            
            // Text Message
        } else {
            if ([[preferences objectForKey:@"customValueSwitchTxt"] integerValue] == 1) {
                hue = [[preferences objectForKey:@"hueSliderValueTxt"] floatValue];
                sat = [[preferences objectForKey:@"satSliderValueTxt"] floatValue];
            } else {
                NSInteger colorIndexPath = [[preferences objectForKey:@"presetListTxt"] integerValue];
                hue = (isUniversal) ? redBubblePresets[colorIndexPath] : greenBubblePresets[colorIndexPath];
            }
        }
        
        // Apply transformations and return the new UIImage
        return [color imageByAdjustingHue:hue saturation:sat lightness:0.0f];
        
    } else {
        return %orig;
    }
}

%end

__attribute__((constructor)) static void internalizer_init() {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    preferences = [[NSDictionary alloc] initWithContentsOfFile:PreferencesFilePath];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesChangedCallback, CFSTR(PreferencesChangedNotification), NULL, CFNotificationSuspensionBehaviorCoalesce);
    
    [pool release];
}