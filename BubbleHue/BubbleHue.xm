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
#import <UIKit/UIKit.h>

@interface CKGradientView : UIView
- (id)gradient;
@end

%hook CKGradientView

// I'll replace each color with a shifted hue. Color class = 
- (id)gradient {
    UIImage *color = %orig;
    // Hue adjusts by degrees: 0-360
    return (color) ? [color imageByAdjustingHue:200.0f saturation:0 lightness:0] : %orig;
}

%end