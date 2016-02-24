//
//  ColorPickerView.m
//
//  Created by Rakib Rz on 18/02/16.
//  Copyright © 2016 Rakib Rz. All rights reserved.
//

#import "RzColorPickerView.h"

@implementation RzColorPickerWheelGradientView

- (void) setColor1:(UIColor*)color
{
    if (color1 != color)
    {
        color1 = [color copy];
        [self setupGradient];
        [self setNeedsDisplay];
    }
}

- (void) setColor2:(UIColor*)color
{
    if (color2 != color)
    {
        color2 = [color copy];
        [self setupGradient];
        [self setNeedsDisplay];
    }
}

- (void) setupGradient
{
    if (color1 == nil || color2 == nil)
        return;
    
    const CGFloat* c1 = CGColorGetComponents(color1.CGColor);
    const CGFloat* c2 = CGColorGetComponents(color2.CGColor);
    CGFloat colors[] = { c1[0], c1[1], c1[2], 1.0f, c2[0], c2[1], c2[2], 1.0f };
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    if (gradient != NULL)
        CGGradientRelease(gradient);
    
    gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors) / (sizeof(colors[0]) * 4));
    CGColorSpaceRelease(rgb);
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect clippingRect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    CGPoint endPoints[] = { CGPointMake(0.0f, 0.0f), CGPointMake(self.frame.size.width, 0.0f) };
    
    CGContextSaveGState(context);
    CGContextClipToRect(context, clippingRect);
    CGContextDrawLinearGradient(context, gradient, endPoints[0], endPoints[1], 0.0f);
    CGContextRestoreGState(context);
}

@end

@implementation RzColorPickerView
@synthesize currentColor;
@synthesize colorSelectedBlock;

- (id) initWithFrame:(CGRect)frm
{
    if ((self = [super initWithFrame:frm]) == nil) { return nil; }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self createViews];
    
    return self;
}

- (void) createViews
{
    NSScanner *scanner = [NSScanner scannerWithString:@"D1D1D1"];
    unsigned hexValue = 0;
    [scanner scanHexInt:&hexValue];
    [self setBackgroundColor:MAKECOLORFROMHEX(hexValue)];
    
//    [self setBackgroundColor:[UIColor colorWithHexString:@"D1D1D1"]];

    borderColor = [UIColor colorWithWhite:0.2f alpha:0.3f];
    UIFont *defaultFont;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    NSString *imageName = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"colorMap" ofType:@"png"];
    ImageViewColorMap = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:imageName]];
    [ImageViewColorMap.layer setBorderWidth:2.0f];
    [ImageViewColorMap.layer setBorderColor:borderColor.CGColor];
    [ImageViewColorMap setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:ImageViewColorMap];

    labelColorSample = [[UILabel alloc] init];
    [labelColorSample.layer setCornerRadius:6.0f];
    [labelColorSample.layer setMasksToBounds:YES];
    [labelColorSample.layer setBorderWidth:1.0f];
    [labelColorSample.layer setBorderColor:borderColor.CGColor];
    [self addSubview:labelColorSample];
    
    if (IsIPhone)
    {
        imageName = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"done@2x" ofType:@"png"];
        defaultFont = [UIFont fontWithName:@"Helvetica Neue" size:20];
    }
    else
    {
        imageName = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"done" ofType:@"png"];
        defaultFont = [UIFont fontWithName:@"Helvetica Neue" size:35];
    }
    
    btnDone = [[UIButton alloc] init];
    [btnDone setImage:[[UIImage alloc] initWithContentsOfFile:imageName] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone sizeToFit];
    [self addSubview:btnDone];
    
    lblHex = [[UILabel alloc] init];
    [lblHex setText:@"#"];
    [lblHex setFont:defaultFont];
    [lblHex sizeToFit];
    [lblHex setTextAlignment:NSTextAlignmentCenter];
    [lblHex setTextColor:[UIColor darkGrayColor]];
    [self addSubview:lblHex];

    lblRed= [[UILabel alloc] init];
    [lblRed setText:@"R :"];
    [lblRed setFont:defaultFont];
    [lblRed sizeToFit];
    [lblRed setTextAlignment:NSTextAlignmentCenter];
    [lblRed setTextColor:[UIColor darkGrayColor]];
    [self addSubview:lblRed];

    lblGreen = [[UILabel alloc] init];
    [lblGreen setText:@"G :"];
    [lblGreen setFont:defaultFont];
    [lblGreen sizeToFit];
    [lblGreen setTextAlignment:NSTextAlignmentCenter];
    [lblGreen setTextColor:[UIColor darkGrayColor]];
    [self addSubview:lblGreen];

    lblBlue = [[UILabel alloc] init];
    [lblBlue setText:@"B :"];
    [lblBlue setFont:defaultFont];
    [lblBlue sizeToFit];
    [lblBlue setTextAlignment:NSTextAlignmentCenter];
    [lblBlue setTextColor:[UIColor darkGrayColor]];
    [self addSubview:lblBlue];
    
    txtHexCode = [[UITextField alloc] init];
    [txtHexCode setDelegate:self];
    [txtHexCode setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [txtHexCode setFont:defaultFont];
    [txtHexCode setTextColor:[UIColor darkGrayColor]];
    [txtHexCode setTextAlignment:NSTextAlignmentCenter];
    [txtHexCode setBorderStyle:UITextBorderStyleRoundedRect];
    [txtHexCode setReturnKeyType:UIReturnKeyDone];
    [self addSubview:txtHexCode];
    
    txtRed = [[UITextField alloc] init];
    [txtRed setDelegate:self];
    [txtRed setFont:defaultFont];
    [txtRed setTextColor:[UIColor darkGrayColor]];
    [txtRed setTextAlignment:NSTextAlignmentCenter];
    [txtRed setBorderStyle:UITextBorderStyleRoundedRect];
    [txtRed setReturnKeyType:UIReturnKeyDone];
    [self addSubview:txtRed];
    
    txtGreen = [[UITextField alloc] init];
    [txtGreen setDelegate:self];
    [txtGreen setFont:defaultFont];
    [txtGreen setTextColor:[UIColor darkGrayColor]];
    [txtGreen setTextAlignment:NSTextAlignmentCenter];
    [txtGreen setBorderStyle:UITextBorderStyleRoundedRect];
    [txtGreen setReturnKeyType:UIReturnKeyDone];
    [self addSubview:txtGreen];
    
    txtBlue = [[UITextField alloc] init];
    [txtBlue setDelegate:self];
    [txtBlue setFont:defaultFont];
    [txtBlue setTextColor:[UIColor darkGrayColor]];
    [txtBlue setTextAlignment:NSTextAlignmentCenter];
    [txtBlue setBorderStyle:UITextBorderStyleRoundedRect];
    [txtBlue setReturnKeyType:UIReturnKeyDone];
    [self addSubview:txtBlue];
    
    imageName = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"indicator@2x" ofType:@"png"];
    
    brightnessView = [self createBarViewWithBorderColor];
    brightnessIndicator = [self createIndicator:[[UIImage alloc] initWithContentsOfFile:imageName]];
    saturationView = [self createBarViewWithBorderColor];
    saturationIndicator = [self createIndicator:[[UIImage alloc] initWithContentsOfFile:imageName]];
    
    if (IsIPhone)
        colorBubble = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    else
        colorBubble = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];

    [colorBubble.layer setCornerRadius:CGRectGetWidth(colorBubble.frame)/2];
    [colorBubble.layer setBorderColor:[UIColor colorWithWhite:0.9f alpha:0.8f].CGColor];
    [colorBubble.layer setBorderWidth:2.0f];
    [colorBubble.layer setShadowColor:[UIColor blackColor].CGColor];
    [colorBubble.layer setShadowOffset:CGSizeZero];
    [colorBubble.layer setShadowRadius:1.0f];
    [colorBubble.layer setShadowOpacity:0.5f];
    [colorBubble.layer setShouldRasterize:YES];
    [colorBubble.layer setRasterizationScale:[UIScreen mainScreen].scale];
    [self addSubview:colorBubble];
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) // Landscap
    {
        if (IsIPhone)
        {
            [ImageViewColorMap setFrame:CGRectMake(15, 15, CGRectGetHeight(self.frame) - 30, CGRectGetHeight(self.frame) - 30)];
            
            [lblHex setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame)+15, 15, CGRectGetWidth(lblHex.frame), 30)];
            [txtHexCode setFrame:CGRectMake(CGRectGetMaxX(lblHex.frame)+5, 15, 115, 30)];
            
            [btnDone setFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(btnDone.frame) - 15, 15, CGRectGetWidth(btnDone.frame), CGRectGetHeight(btnDone.frame))];
            
            [saturationView setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame)+15, CGRectGetMaxY(txtHexCode.frame) + 15, CGRectGetWidth(self.frame) - CGRectGetMaxX(ImageViewColorMap.frame) - 30, 30)];
            [brightnessView setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame)+15, CGRectGetMaxY(saturationView.frame) + 15, CGRectGetWidth(self.frame) - CGRectGetMaxX(ImageViewColorMap.frame) - 30, 30)];
            
            [lblRed setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame)+15, CGRectGetMaxY(brightnessView.frame)+15, CGRectGetWidth(lblRed.frame), 30)];
            [txtRed setFrame:CGRectMake(CGRectGetMaxX(lblRed.frame)+5, CGRectGetMaxY(brightnessView.frame)+15, 50, 30)];
            
            [lblGreen setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame)+15, CGRectGetMaxY(txtRed.frame) + 15, CGRectGetWidth(lblGreen.frame), 30)];
            [txtGreen setFrame:CGRectMake(CGRectGetMaxX(lblGreen.frame)+3, CGRectGetMaxY(txtRed.frame) + 15, 50, 30)];
            
            [lblBlue setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame)+15, CGRectGetMaxY(txtGreen.frame) + 15,CGRectGetWidth(lblBlue.frame), 30)];
            [txtBlue setFrame:CGRectMake(CGRectGetMaxX(lblBlue.frame)+5, CGRectGetMaxY(txtGreen.frame) + 15, 50, 30)];
            
            [labelColorSample setFrame:CGRectMake(CGRectGetMaxX(txtRed.frame) + 15, CGRectGetMaxY(brightnessView.frame) + 15, CGRectGetWidth(self.frame) - CGRectGetMaxX(txtRed.frame) - 30 , 120)];
        }
        else
        {
            [ImageViewColorMap setFrame:CGRectMake(30, 30, 580, 580)];
            [saturationView setFrame:CGRectMake(30, CGRectGetMaxY(ImageViewColorMap.frame)+30, (CGRectGetWidth(self.frame)/2) - 45, 60)];
            [brightnessView setFrame:CGRectMake(CGRectGetMaxX(saturationView.frame) + 30, CGRectGetMaxY(ImageViewColorMap.frame)+30, (CGRectGetWidth(self.frame)/2) - 45, 60)];
            
            [btnDone setFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(btnDone.frame) - 15, 30, CGRectGetWidth(btnDone.frame), CGRectGetHeight(btnDone.frame))];
            
            [lblRed setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame)+30, CGRectGetMaxY(btnDone.frame)+30, CGRectGetWidth(lblRed.frame), 60)];
            [txtRed setFrame:CGRectMake(CGRectGetMaxX(lblRed.frame)+10, CGRectGetMaxY(btnDone.frame)+30, 80, 60)];
            
            [lblGreen setFrame:CGRectMake(CGRectGetMaxX(txtRed.frame)+20, CGRectGetMaxY(btnDone.frame) + 30, CGRectGetWidth(lblGreen.frame), 60)];
            [txtGreen setFrame:CGRectMake(CGRectGetMaxX(lblGreen.frame)+10, CGRectGetMaxY(btnDone.frame) + 30, 80, 60)];
            
            [lblBlue setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame)+30, CGRectGetMaxY(txtGreen.frame) + 30,CGRectGetWidth(lblBlue.frame), 60)];
            [txtBlue setFrame:CGRectMake(CGRectGetMaxX(lblBlue.frame)+10, CGRectGetMaxY(txtGreen.frame) + 30, 80, 60)];
            
            [lblHex setFrame:CGRectMake(CGRectGetMaxX(txtBlue.frame)+20, CGRectGetMaxY(txtGreen.frame) + 30, CGRectGetWidth(lblHex.frame), 60)];
            [txtHexCode setFrame:CGRectMake(CGRectGetMaxX(lblHex.frame)+5, CGRectGetMaxY(txtGreen.frame) + 30, CGRectGetWidth(self.frame) - CGRectGetMaxX(lblHex.frame) - 40, 60)];

            [labelColorSample setFrame:CGRectMake(CGRectGetMaxX(ImageViewColorMap.frame) + 30, CGRectGetMaxY(lblBlue.frame) + 30, CGRectGetWidth(self.frame) - CGRectGetMaxX(ImageViewColorMap.frame) - 60 , CGRectGetWidth(self.frame) - CGRectGetMaxX(ImageViewColorMap.frame) - 115)];
        }
     }
    else // Portrait
    {
        if (IsIPhone)
        {
            [btnDone setFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(btnDone.frame) - 10, 20, CGRectGetWidth(btnDone.frame), CGRectGetHeight(btnDone.frame))];

            [lblHex setFrame:CGRectMake(15, 20, CGRectGetWidth(lblHex.frame), 30)];
            [txtHexCode setFrame:CGRectMake(CGRectGetMaxX(lblHex.frame)+5, 20,  115, 30)];
            [txtHexCode setCenter:CGPointMake(self.center.x, txtHexCode.center.y)];
            [lblHex setCenter:CGPointMake(CGRectGetMinX(txtHexCode.frame) - CGRectGetWidth(lblHex.frame), lblHex.center.y)];

            [ImageViewColorMap setFrame:CGRectMake(15, CGRectGetMaxY(txtHexCode.frame) + 10, CGRectGetWidth(self.frame) -  30, CGRectGetWidth(self.frame) -  30)];
            
            [saturationView setFrame:CGRectMake(15, CGRectGetMaxY(ImageViewColorMap.frame)+10, CGRectGetWidth(self.frame) - 30, 30)];
            [brightnessView setFrame:CGRectMake(15, CGRectGetMaxY(saturationView.frame) + 10, CGRectGetWidth(self.frame) - 30, 30)];

            [lblRed setFrame:CGRectMake(15, CGRectGetMaxY(brightnessView.frame)+10, CGRectGetWidth(lblRed.frame), 30)];
            [txtRed setFrame:CGRectMake(CGRectGetMaxX(lblRed.frame)+5, CGRectGetMaxY(brightnessView.frame)+10, 50, 30)];
            
            [lblGreen setFrame:CGRectMake(15, CGRectGetMaxY(lblRed.frame) + 10, CGRectGetWidth(lblGreen.frame), 30)];
            [txtGreen setFrame:CGRectMake(CGRectGetMaxX(lblGreen.frame)+3, CGRectGetMaxY(txtRed.frame) + 10, 50, 30)];
            
            [lblBlue setFrame:CGRectMake(15, CGRectGetMaxY(lblGreen.frame) + 10, CGRectGetWidth(lblBlue.frame), 30)];
            [txtBlue setFrame:CGRectMake(CGRectGetMaxX(lblBlue.frame)+5, CGRectGetMaxY(txtGreen.frame) + 10, 50, 30)];

            [labelColorSample setFrame:CGRectMake(CGRectGetMaxX(txtRed.frame)+15, CGRectGetMaxY(brightnessView.frame)+10, CGRectGetWidth(self.frame) - CGRectGetMaxX(txtRed.frame) - 30, 110)];
         }
        else
        {
            [btnDone setFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(btnDone.frame) - 15, 30, CGRectGetWidth(btnDone.frame), CGRectGetHeight(btnDone.frame))];

            [saturationView setFrame:CGRectMake(30, 30, (CGRectGetWidth(self.frame) /2) - CGRectGetWidth(btnDone.frame), 60)];
            [brightnessView setFrame:CGRectMake(CGRectGetMaxX(saturationView.frame)+30, 30,(CGRectGetWidth(self.frame) /2)- CGRectGetWidth(btnDone.frame), 60)];

            [ImageViewColorMap setFrame:CGRectMake(30, CGRectGetMaxY(saturationView.frame) + 30, CGRectGetWidth(self.frame)-60, CGRectGetWidth(self.frame)-60)];

            [lblRed setFrame:CGRectMake(30, CGRectGetMaxY(ImageViewColorMap.frame)+30, CGRectGetWidth(lblRed.frame), 60)];
            [txtRed setFrame:CGRectMake(CGRectGetMaxX(lblRed.frame)+10, CGRectGetMaxY(ImageViewColorMap.frame)+30, 80, 60)];
            
            [lblGreen setFrame:CGRectMake(CGRectGetMaxX(txtRed.frame)+30, CGRectGetMaxY(ImageViewColorMap.frame) + 30, CGRectGetWidth(lblGreen.frame), 60)];
            [txtGreen setFrame:CGRectMake(CGRectGetMaxX(lblGreen.frame)+10, CGRectGetMaxY(ImageViewColorMap.frame)+30, 80, 60)];
            
            [lblBlue setFrame:CGRectMake(30, CGRectGetMaxY(txtRed.frame) + 30, CGRectGetWidth(lblBlue.frame), 60)];
            [txtBlue setFrame:CGRectMake(CGRectGetMaxX(lblBlue.frame)+10, CGRectGetMaxY(txtRed.frame) + 30, 80, 60)];
            
            [lblHex setFrame:CGRectMake(CGRectGetMaxX(txtBlue.frame)+30, CGRectGetMaxY(txtRed.frame) + 30, CGRectGetWidth(lblHex.frame), 60)];
            [txtHexCode setFrame:CGRectMake(CGRectGetMaxX(lblHex.frame)+10, CGRectGetMaxY(txtRed.frame) + 30, 200, 60)];
            
            [labelColorSample setFrame:CGRectMake(CGRectGetMaxX(txtHexCode.frame) + 30, CGRectGetMaxY(ImageViewColorMap.frame) + 30, CGRectGetWidth(self.frame) - CGRectGetMaxX(txtHexCode.frame) - 60 , 150)];
        }
    }
    if (currentColor)
        self.color = currentColor;
    else
        self.color = [UIColor whiteColor];

    [self updateIndicatorsPosition];
    [self updateColorBubblePosition];
}

-(void)doneButtonTapped:(UIButton *)sender
{
    [self endEditing:YES];
    [UIView animateWithDuration:1 animations:^{
        [self setFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }];
    self.colorSelectedBlock(currentColor);
}

- (void)doneWithSelectedColor:(RzColorPickerColorSelectedBlock)newColor
{
    colorSelectedBlock = newColor;
}


- (RzColorPickerWheelGradientView *)createBarViewWithBorderColor
{
    RzColorPickerWheelGradientView *gradientView = [[RzColorPickerWheelGradientView alloc] init];
    [gradientView.layer setCornerRadius:6.0f];
    [gradientView.layer setMasksToBounds:YES];
    [gradientView.layer setBorderWidth:1.0f];
    [gradientView.layer setBorderColor:borderColor.CGColor];

    [self addSubview:gradientView];
    return gradientView;
}

- (UIImageView*)createIndicator:(UIImage *)image
{
    int pointH, pointW;
    
    if (IsIPhone)
    {
        pointH = 36;
        pointW = 12;
    }
    else
    {
        pointH = 66;
        pointW = 24;
    }

    UIImageView* indicator = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, brightnessView.center.y, pointW, pointH)];
    [indicator setImage:image];
    
    [indicator.layer setShadowColor:[UIColor blackColor].CGColor];
    [indicator.layer setShadowOffset:CGSizeZero];
    [indicator.layer setShadowRadius:1.0f];
    [indicator.layer setShadowOpacity:0.8f];
    [indicator.layer setShouldRasterize:YES];
    [indicator.layer setRasterizationScale:[UIScreen mainScreen].scale];
    [self addSubview:indicator];
    return indicator;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField !=txtHexCode)
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    UIColor *generateColor;
    if (textField !=txtHexCode)
    {
        red = [txtRed.text floatValue];
        green = [txtGreen.text floatValue];
        blue = [txtBlue.text floatValue];
        generateColor = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1.0f];
        
        [self setColor:generateColor];
        return [textField.text floatValue] <= 255;
    }
    else
    {
        if ([textField.text length] == 6)
        {
            NSScanner *scanner = [NSScanner scannerWithString:textField.text];
            unsigned hexValue = 0;
            [scanner scanHexInt:&hexValue];
            generateColor = MAKECOLORFROMHEX(hexValue);
            
//            generateColor = [UIColor colorWithHexString:textField.text];

            if (generateColor != nil)
                [self setColor:generateColor];
        }
    }
        return YES;
}

- (BOOL) textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textField != txtHexCode)
    {
        NSCharacterSet *numbersOnly = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:numbersOnly] componentsJoinedByString:@""];
        
        return [string isEqualToString:filteredString] && [text stringByReplacingCharactersInRange:range withString:string].length <= 3;
    }
    else
        return ([text stringByReplacingCharactersInRange:range withString:string].length <= 6);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{    
    return [textField resignFirstResponder];
}

- (void) setColor:(UIColor*)newColor
{
//    if (![currentColor isEqual:newColor])
//    {
        [newColor getHue:&hueValue saturation:&saturationValue brightness:&brightnessValue alpha:NULL];
        CGColorSpaceModel colorSpaceModel = [newColor colorSpaceModel];
//    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(newColor.CGColor));
    
        if (colorSpaceModel == kCGColorSpaceModelMonochrome && newColor != nil)
        {
            const CGFloat *pixel = CGColorGetComponents(newColor.CGColor);
            currentColor = [UIColor colorWithHue:0 saturation:0 brightness:pixel[0] alpha:1.0];
        }
        else
            currentColor = [newColor copy];
        
        NSString* strHexCode = [newColor hexStringFromColorNoAlpha];
        if ([strHexCode caseInsensitiveCompare:txtHexCode.text] != NSOrderedSame)
            [txtHexCode setText:strHexCode];
        
        [self updateIndicatorsColor];
        [self updateIndicatorsPosition];
        [self updateColorBubblePosition];
        
        [currentColor getRed:&red green:&green blue:&blue alpha:NULL];
        
        int redValue = red * 255;
        int greenValue = green * 255;
        int blueValue = blue * 255;
        
        [txtRed setText:[NSString stringWithFormat:@"%d",redValue]];
        [txtGreen setText:[NSString stringWithFormat:@"%d",greenValue]];
        [txtBlue setText:[NSString stringWithFormat:@"%d",blueValue]];
        [labelColorSample setBackgroundColor:currentColor];
//    }
}

- (void) updateIndicatorsPosition
{
    [currentColor getHue:nil saturation:&saturationValue brightness:&brightnessValue alpha:nil];
    
    CGPoint brightnessPosition;
    brightnessPosition.x = (1.0f - brightnessValue) * brightnessView.frame.size.width + brightnessView.frame.origin.x;
    brightnessPosition.y = brightnessView.center.y;
    [brightnessIndicator setCenter:brightnessPosition];
    
    CGPoint saturationPosition;
    saturationPosition.x = (1.0f - saturationValue) * saturationView.frame.size.width + saturationView.frame.origin.x;
    saturationPosition.y = saturationView.center.y;
    [saturationIndicator setCenter:saturationPosition];
}

- (void) setColorBubblePosition:(CGPoint)position
{
    [colorBubble setCenter:position];
}

- (void) updateColorBubblePosition
{
    CGPoint hueSatPosition;
    
    hueSatPosition.x = (hueValue * ImageViewColorMap.frame.size.width) + ImageViewColorMap.frame.origin.x;
    hueSatPosition.y = (1.0f - saturationValue) * ImageViewColorMap.frame.size.height + ImageViewColorMap.frame.origin.y;
    [self setColorBubblePosition:hueSatPosition];
    [self updateIndicatorsColor];
}

- (void) updateIndicatorsColor
{
    UIColor* brightnessColor1 = [UIColor colorWithHue:hueValue saturation:saturationValue brightness:1.0f alpha:1.0f];
    UIColor* brightnessColor2 = [UIColor colorWithHue:hueValue saturation:saturationValue brightness:0.0f alpha:1.0f];
    [brightnessView setColor1:brightnessColor1];
    [brightnessView setColor2:brightnessColor2];
    [colorBubble setBackgroundColor:brightnessColor1];

    UIColor* saturationColor1 = [UIColor colorWithHue:hueValue saturation:0.0f brightness:1.0f alpha:1.0f];
    UIColor* saturationColor2 = [UIColor colorWithHue:hueValue saturation:1.0f brightness:1.0f alpha:1.0f];
    [saturationView setColor1:saturationColor2];
    [saturationView setColor2:saturationColor1];
}

- (void) updateHueWithMovement:(CGPoint)position
{
    hueValue = (position.x - ImageViewColorMap.frame.origin.x) / ImageViewColorMap.frame.size.width;
    saturationValue = 1.0f -  (position.y - ImageViewColorMap.frame.origin.y) / ImageViewColorMap.frame.size.height;
    
    UIColor* topColor = [UIColor colorWithHue:hueValue saturation:saturationValue brightness:brightnessValue alpha:1.0f];
    UIColor* gradientColor = [UIColor colorWithHue:hueValue saturation:saturationValue brightness:1.0f alpha:1.0f];
    
    [colorBubble setBackgroundColor:gradientColor];
    [self updateIndicatorsColor];
    [self setColor:topColor];
}

- (void) updateBrightnessWithMovement:(CGPoint)position
{
    brightnessValue = 1.0f - ((position.x - brightnessView.frame.origin.x) / brightnessView.frame.size.width);
    
    UIColor* topColor = [UIColor colorWithHue:hueValue saturation:saturationValue brightness:brightnessValue alpha:1.0f];
    [self setColor:topColor];
}

- (void) updateSaturationWithMovement:(CGPoint)position
{
    saturationValue = 1.0f - ((position.x - saturationView.frame.origin.x) / saturationView.frame.size.width);
    
    UIColor* topColor = [UIColor colorWithHue:hueValue saturation:saturationValue brightness:brightnessValue alpha:1.0f];
    [self setColor:topColor];
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];

    for (UITouch* touch in touches)
        [self handleTouchEvent:[touch locationInView:self]];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesMoved:touches withEvent:event];
    for (UITouch* touch in touches)
        [self handleTouchEvent:[touch locationInView:self]];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    focusView = nil;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    focusView = nil;
}

- (void) handleTouchEvent:(CGPoint)position
{
    if (focusView == ImageViewColorMap || (focusView == nil && CGRectContainsPoint(ImageViewColorMap.frame, position)))
    {
        position.x = MIN(MAX(CGRectGetMinX(ImageViewColorMap.frame), position.x), CGRectGetMaxX(ImageViewColorMap.frame) - 1);
        position.y = MIN(MAX(CGRectGetMinY(ImageViewColorMap.frame), position.y), CGRectGetMaxY(ImageViewColorMap.frame) - 1);
        focusView = ImageViewColorMap;
        
        [self setColorBubblePosition:position];
        [self updateHueWithMovement:position];
    }
    else if (focusView == brightnessView || (focusView == nil && CGRectContainsPoint(brightnessView.frame, position)))
    {
        position.x = MIN(MAX(CGRectGetMinX(brightnessView.frame), position.x), CGRectGetMaxX(brightnessView.frame) - 1);
        position.y = MIN(MAX(CGRectGetMinY(brightnessView.frame), position.y), CGRectGetMaxY(brightnessView.frame) - 1);
        
        focusView = brightnessView;
        [brightnessIndicator setCenter:CGPointMake(position.x, brightnessView.center.y)];
        [self updateBrightnessWithMovement:position];
    }
    else if (saturationView != nil && (focusView == saturationView || (focusView == nil && CGRectContainsPoint(saturationView.frame, position))))
    {
        position.x = MIN(MAX(CGRectGetMinX(saturationView.frame), position.x), CGRectGetMaxX(saturationView.frame) - 1);
        position.y = MIN(MAX(CGRectGetMinY(saturationView.frame), position.y), CGRectGetMaxY(saturationView.frame) - 1);
        
        focusView = saturationView;
        [saturationIndicator setCenter:CGPointMake(position.x, saturationView.center.y)];
        [self updateSaturationWithMovement:position];
    }
}

@end

