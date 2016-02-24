# RzColorPickerView
The best Color Picker is here..... You can set using RGB value &amp; HexCode too

![screenshot](https://cloud.githubusercontent.com/assets/13728552/13277454/f522420e-daee-11e5-9b6d-b223c6b9c4c7.png)

![screenshot1](https://cloud.githubusercontent.com/assets/13728552/13277455/f6962bc8-daee-11e5-86dc-18dcc7599bed.png)

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

