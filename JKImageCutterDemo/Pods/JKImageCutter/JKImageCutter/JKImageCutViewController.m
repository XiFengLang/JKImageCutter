//
//  JKImageCutViewController.m
//  JKImageCutter
//
//  Created by 蒋鹏 on 17/2/28.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKImageCutViewController.h"

@interface JKImageCutViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView * scrollView;


@property (nonatomic, weak) UIImageView * imageView;


/**
 图片资源
 */
@property (nonatomic, strong) UIImage * imageSource;


/**
 结果回调
 */
@property (nonatomic, copy) JKImageCutterCompletionHandler completionHandler;


/**
 缩放后的图片大小，并按此size重绘图片
 */
@property (nonatomic, assign) CGSize imageSize;


@property (nonatomic, assign, readonly) CGFloat scrollViewWH;

@end

@implementation JKImageCutViewController

CGSize JKImageCutterScreenSize() {
    return [UIScreen mainScreen].bounds.size;
}


- (CGFloat)scrollViewWH {
    return MIN(JKImageCutterScreenSize().width, JKImageCutterScreenSize().height);
}


- (void)cutImage:(UIImage *)imageSource completionHandler:(JKImageCutterCompletionHandler)completionHandler {
    self.imageSource = imageSource;
    self.completionHandler = completionHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if (self.imageSource == nil) {
        self.completionHandler = nil;
        [self cancelOrDropOut];
        return;
    }
    
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 1.0;
    self.scrollView = scrollView;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor redColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    self.imageView = imageView;

    scrollView.clipsToBounds = NO;
    self.view.clipsToBounds = YES;

    
    /// 计算布局
    CGFloat imageHeight = self.scrollViewWH * (self.imageSource.size.height / self.imageSource.size.width);
    CGFloat imageWidth = self.scrollViewWH;
    if (imageHeight < self.scrollViewWH) {
        imageWidth = self.scrollViewWH * (imageWidth / imageHeight);
        imageHeight = self.scrollViewWH;
    }
    self.imageSize = CGSizeMake(imageWidth, imageHeight);
    
    
    scrollView.frame = CGRectMake((JKImageCutterScreenSize().width - self.scrollViewWH) / 2.0,
                                  (JKImageCutterScreenSize().height - self.scrollViewWH) / 2.0,
                                  self.scrollViewWH, self.scrollViewWH);
    imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
    scrollView.contentSize = CGSizeMake(self.imageSize.width + 0.25, self.imageSize.height + 0.25);
    scrollView.contentOffset = CGPointMake(0.5 * (self.imageSize.width - self.scrollViewWH), 0.5 * (self.imageSize.height - self.scrollViewWH));
    
    imageView.image = self.imageSource = [self resizeImageAppropriately];
    
    
    /// 双击缩放手势
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
    
    
    
    /// 遮罩层
    [self addMaskLayer];
    
    /// 顶部按钮
    [self addBottomButtons];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)addMaskLayer {
    UIView * maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    maskView.userInteractionEnabled = NO;
    [self.view addSubview:maskView];
    

    
    CGFloat lineWidth = 2.0f;
    CGFloat ovalFrameY = JKImageCutterScreenSize().width > JKImageCutterScreenSize().height ? lineWidth : (JKImageCutterScreenSize().height - JKImageCutterScreenSize().width) / 2.0 + lineWidth;
    CGRect ovalFrame = CGRectMake((JKImageCutterScreenSize().width - self.scrollViewWH) / 2.0 + lineWidth, ovalFrameY, self.scrollViewWH - lineWidth * 2, self.scrollViewWH - lineWidth * 2);
    
    UIBezierPath * subPath = nil;
    if (self.type == JKImageCutterTypeRounded) {
        subPath = [UIBezierPath bezierPathWithRoundedRect:ovalFrame cornerRadius:self.scrollViewWH * 0.5];
    } else {
        subPath = [UIBezierPath bezierPathWithRoundedRect:ovalFrame cornerRadius:0];
    }
    [subPath closePath];
    
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [bezierPath appendPath:subPath.bezierPathByReversingPath];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = bezierPath.CGPath;
    maskView.layer.mask = maskLayer;
    
    CAShapeLayer * borderLayer = [CAShapeLayer layer];
    UIBezierPath * borderPath = [UIBezierPath bezierPathWithCGPath:subPath.CGPath];
    borderLayer.path = borderPath.CGPath;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.lineWidth = lineWidth;
    [maskView.layer addSublayer:borderLayer];
    
}


- (void)addBottomButtons {
    CGFloat buttonWidth = 50;
    CGFloat margin = 55;
    
    NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"JKImageCutter")];
    NSBundle *sourceBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"JKImageCutter" ofType:@"bundle"]];
    
    UIImage * cancelImage = [self redrawButtonBackgroundImage:[UIImage imageWithContentsOfFile:[sourceBundle pathForResource:@"JKImageCutter_Cancel.png" ofType:nil]]];
    UIButton * cancelButton = [self buttonWithImage:cancelImage frame:CGRectMake(margin, JKImageCutterScreenSize().height - 30 - buttonWidth, buttonWidth, buttonWidth) target:self action:@selector(cancelOrDropOut)];
    [self.view addSubview:cancelButton];
    
    UIImage * selectedImage = [self redrawButtonBackgroundImage:[UIImage imageWithContentsOfFile:[sourceBundle pathForResource:@"JKImageCutter_Selected.png" ofType:nil]]];
    UIButton * doneButton = [self buttonWithImage:selectedImage frame:CGRectMake(JKImageCutterScreenSize().width - margin - buttonWidth, cancelButton.frame.origin.y, buttonWidth, buttonWidth) target:self action:@selector(clipImage)];
    [self.view addSubview:doneButton];
}


#pragma mark - 工厂方法

- (UIImage *)redrawButtonBackgroundImage:(UIImage *)image {
    CGSize buttonSize = CGSizeMake(50, 50);
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:20 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    bezierPath.lineWidth = 2.0;
    
    UIGraphicsBeginImageContextWithOptions(buttonSize, NO, [UIScreen mainScreen].scale);
    [[UIColor blackColor] setFill];
    [bezierPath fill];
    
    [image drawInRect:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    UIImage * image_copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image_copy;
}


- (UIButton *)buttonWithImage:(UIImage *)image frame:(CGRect)frame target:(id)target action:(SEL)action {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = frame;
    return button;
}


- (UIImage *)resizeImageAppropriately {
    UIGraphicsBeginImageContextWithOptions(self.imageSize, NO, UIScreen.mainScreen.scale);
    [self.imageSource drawInRect:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale == 1.0) {
        scrollView.contentSize = CGSizeMake(self.imageSize.width + 0.25, self.imageSize.height + 0.25);
    }
}


#pragma mark - 点击事件


/**
 双击定点放大

 @param tapGesture 双击
 */
- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint location = [tapGesture locationInView:self.scrollView];
        CGRect zoomRect = CGRectZero;
        zoomRect.size.height = tapGesture.view.frame.size.height / 3.0;
        zoomRect.size.width  = tapGesture.view.frame.size.width  / 3.0;
        zoomRect.origin.x = location.x - (zoomRect.size.width  / 2.0);
        zoomRect.origin.y = location.y - (zoomRect.size.height / 2.0) + self.scrollView.contentInset.top;
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}



/**
 根据画框裁剪图片
 */
- (void)clipImage {
    CGRect clipRange = CGRectMake(- self.scrollView.contentOffset.x,
                                  - self.scrollView.contentOffset.y,
                                  self.imageView.frame.size.width,
                                  self.imageView.frame.size.height);
    
    CGRect maskRange = CGRectMake(0, 0, self.scrollView.frame.size.height,
                                  self.scrollView.frame.size.height);
    
    UIBezierPath * bezierPath = nil;
    if (self.type == JKImageCutterTypeSquare) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:maskRange cornerRadius:0];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:maskRange cornerRadius:maskRange.size.width * 0.5];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.scrollView.frame.size, NO, [UIScreen mainScreen].scale);
    [bezierPath addClip];
    [self.imageSource drawInRect:clipRange];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    if (self.completionHandler) {
        self.completionHandler(image);
        self.completionHandler = nil;
    }
    [self cancelOrDropOut];
}



/**
 退出
 */
- (void)cancelOrDropOut {
    if (self.navigationController) {
        if (self.navigationController.presentingViewController) {
            [self.navigationController dismissViewControllerAnimated:true completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:true];
        }
    } else if (self.presentationController) {
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}


#pragma mark - 其他

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


/**
 关闭自转

 @return NO
 */
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


/**    隐藏iPhoneX底部的Home条    */
- (BOOL)prefersHomeIndicatorAutoHidden {
    return true;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end


@implementation UINavigationController (JKImageCutter)

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

@end

