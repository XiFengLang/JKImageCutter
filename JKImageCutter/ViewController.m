//
//  ViewController.m
//  JKImageCutter
//
//  Created by 蒋鹏 on 17/2/28.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "JKImageCutViewController.h"

@interface ViewController ()


@property (nonatomic, strong) UIImageView * imageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"JKImageCutter";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushToImageCutVC)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushToImageCutImageVC)];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGFloat imageWidth = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    self.imageView.frame = CGRectMake((size.width - imageWidth) / 2.0, (size.height - imageWidth) / 2.0, imageWidth, imageWidth);
}

- (void)pushToImageCutImageVC {
    JKImageCutViewController * cutVC = [[JKImageCutViewController alloc] init];
    cutVC.type = JKImageCutterTypeRounded;
    [cutVC cutImage:[UIImage imageNamed:@"img1.jpg"] completionHandler:^(UIImage *image) {
        self.imageView.image = image;
    }];
    [self.navigationController pushViewController:cutVC animated:YES];
}

- (void)pushToImageCutVC {
    JKImageCutViewController * cutVC = [[JKImageCutViewController alloc] init];
    cutVC.type = JKImageCutterTypeSquare;
    [cutVC cutImage:[UIImage imageNamed:@"img4.jpg"] completionHandler:^(UIImage *image) {
        self.imageView.image = image;
    }];
    [self.navigationController pushViewController:cutVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
