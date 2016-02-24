//
//  RzColorPicker_UIColor.h
//
//  Created by Rakib Rz on 18/02/16.
//  Copyright © 2016 Rakib Rz. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIColor (RzColorPicker)

// returns a hex string, i.e. #FFEEDDFF (RGBA)
- (NSString*) hexStringFromColor;

// returns a hex string with the alpha set to one, i.e. AABBCCFF (RGB)
- (NSString*) hexStringFromColorAlphaOne;

// returns a hex string with no alpha, i.e. AABBCC (RGB)
- (NSString*) hexStringFromColorNoAlpha;

// human readable string from color
- (NSString*) stringFromColor;

- (CGFloat) alpha;
- (UInt32) rgbHex;
- (UInt32) rgbaHex;
- (BOOL) red:(CGFloat*)red green:(CGFloat*)green blue:(CGFloat*)blue alpha:(CGFloat*)alpha;
- (CGFloat) red;
- (CGFloat) green;
- (CGFloat) blue;
- (CGFloat) white;
- (BOOL) canProvideRGBComponents;
- (CGColorSpaceModel) colorSpaceModel;

+ (UIColor*) colorWithRGBHex:(UInt32)hex;
+ (UIColor*) colorWithRGBAHex:(UInt32)hex;
+ (UIColor*) colorWithHexString:(NSString*)stringToConvert;
+ (UIColor*) colorWithString:(NSString*)stringToConvert;

@end
