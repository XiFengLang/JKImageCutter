# JKImageCutter
通用型的图片裁剪器，支持圆形和方形裁剪，对长图、小图都有做兼容优化。

## Example ##
<img src="http://wx1.sinaimg.cn/mw690/c56eaed1gy1fetak02dwfj208w0gcn4j.jpg" width="230" height="400"><img src="http://wx3.sinaimg.cn/mw690/c56eaed1gy1fetajze9zoj208w0gc422.jpg" width="230" height="400">


## CocoaPods

```
pod 'JKImageCutter','~> 1.0.3'
```

## Usage ##


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
