# JKImageCutter
通用型的图片裁剪器，支持圆形和方形裁剪，对长图、小图都有做兼容优化。

## Example ##

![](https://github.com/XiFengLang/JKImageCutter/blob/master/JKImageCutter01.png) ![](https://github.com/XiFengLang/JKImageCutter/blob/master/JKImageCutter02.png)



## Usage ##


```Object-C
#import "JKImageCutViewController.h"
```

```Object-C
    JKImageCutViewController * cutVC = [[JKImageCutViewController alloc] init];
    cutVC.type = JKImageCutterTypeRounded; // JKImageCutterTypeSquare
    [cutVC cutImage:[UIImage imageNamed:@"img1.jpg"] completionHandler:^(UIImage *image) {
        self.imageView.image = image;
    }];
    [self.navigationController pushViewController:cutVC animated:YES];
    
```


**不用担心Block会造成循环引用，内部已对Block进行优化**

```Object-C

	if (self.completionHandler) {
        self.completionHandler(image);
        self.completionHandler = nil;
    }
```
