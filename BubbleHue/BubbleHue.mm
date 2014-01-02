#line 1 "/Users/stephen/Jailbreak/BubbleHue/BubbleHue/BubbleHue.xm"















#import "UIImage+ImageColoring.h"
#import <UIKit/UIKit.h>

@interface CKGradientView : UIView
- (id)gradient;
@end

#include <logos/logos.h>
#include <substrate.h>
@class CKGradientView; 
static id (*_logos_orig$_ungrouped$CKGradientView$gradient)(CKGradientView*, SEL); static id _logos_method$_ungrouped$CKGradientView$gradient(CKGradientView*, SEL); 

#line 23 "/Users/stephen/Jailbreak/BubbleHue/BubbleHue/BubbleHue.xm"



static id _logos_method$_ungrouped$CKGradientView$gradient(CKGradientView* self, SEL _cmd) {
    UIImage *color = _logos_orig$_ungrouped$CKGradientView$gradient(self, _cmd);
    
    return (color) ? [color imageByAdjustingHue:200.0f saturation:0 lightness:0] : _logos_orig$_ungrouped$CKGradientView$gradient(self, _cmd);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$CKGradientView = objc_getClass("CKGradientView"); MSHookMessageEx(_logos_class$_ungrouped$CKGradientView, @selector(gradient), (IMP)&_logos_method$_ungrouped$CKGradientView$gradient, (IMP*)&_logos_orig$_ungrouped$CKGradientView$gradient);} }
#line 33 "/Users/stephen/Jailbreak/BubbleHue/BubbleHue/BubbleHue.xm"
