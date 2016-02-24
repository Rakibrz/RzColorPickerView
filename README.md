# RzColorPickerView
The best Color Picker is here..... You can set using RGB value &amp; HexCode too


= = = = = = = = = = = = = = = = = = = =

You can set Default color when Load the RzcolorPickerview as setting the value of CURRENTCOLOR..
example : 

  RzColorPickerView *colorPicker = [[RzColorPickerView alloc] initWithFrame:self.view.bounds];
  [colorPicker setCurrentColor:[UIColor redColor]];
  [self.view addSubview:colorPicker];
  
= = = = = = = = = = = = = = = = = = = =

To retrieve a selected Color from RzColorPickerView You have to use "doneWithSelectedColor:" to use the color in your UIColor Object
example : 

  RzColorPickerView *colorPicker = [[RzColorPickerView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:colorPicker];

  [colorPicker doneWithSelectedColor:^(UIColor * _Nonnull newColor)
  {
      UIColor *selectedColor = newColor;
      [self.view setBackgroundColor:selectedColor];
  }];


