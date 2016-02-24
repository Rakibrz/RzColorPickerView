//
//  ViewController.m
//  ColorPickerDemo
//
//  Created by Rakib Rz on 18/02/16.
//  Copyright © 2016 Rakib Rz. All rights reserved.
//

#import "ViewController.h"
#import "RzColorPicker_UIColor.h"
@interface ViewController ()
{
    RzColorPickerView *colorPicker;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    colorPicker = [[RzColorPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:colorPicker];

//    if (!selectedColor)
//        selectedColor = MAKECOLORFROMHEX(0x35C3EA);

    if (!selectedColor)
        selectedColor = [UIColor colorWithHexString:@"35C3EA"];

//    if (!selectedColor)
//        selectedColor = [UIColor colorWithRed:53.0F/255.0F green:195.0F/255.0F blue:234.0F/255.0F alpha:1.0F];
    

    [colorPicker setCurrentColor:selectedColor];

}
- (IBAction)btnColorTapped:(UIButton *)sender
{
    [UIView animateWithDuration:1 animations:^{
        [colorPicker setFrame:self.view.bounds];
    }];

   [colorPicker doneWithSelectedColor:^(UIColor * _Nonnull newColor)
    {
        selectedColor = newColor;
        [self.view setBackgroundColor:selectedColor];

   }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
