//
//  ColorPickerView.h
//
//  Created by Rakib Rz on 18/02/16.
//  Copyright © 2016 Rakib Rz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RzColorPicker_UIColor.h"
#import "DeviceSize.h"

@interface RzColorPickerWheelGradientView : UIView
{
    UIColor *color1, *color2;
    CGGradientRef gradient;
}
@end

@interface RzColorPickerView : UIView <UITextFieldDelegate>
{
    RzColorPickerWheelGradientView *brightnessView, *saturationView;
    UIImageView *brightnessIndicator, *saturationIndicator, *ImageViewColorMap;
    UIView *colorBubble, *focusView;
    CGFloat brightnessValue, hueValue, saturationValue, red, green, blue;

    UILabel *lblRed, *lblGreen, *lblBlue, *lblHex, *labelColorSample;
    UITextField *txtRed, *txtGreen, *txtBlue, *txtHexCode;
    UIColor* borderColor;
    UIButton *btnDone;
}
@property (nonatomic, strong)  UIColor * _Nonnull  currentColor;

typedef  void (^RzColorPickerColorSelectedBlock) (UIColor* _Nonnull newColor);
@property (strong, nonatomic) _Nonnull RzColorPickerColorSelectedBlock colorSelectedBlock;
- (void)doneWithSelectedColor:(_Nonnull RzColorPickerColorSelectedBlock)neColor;

@end
