//
//  JKImageCutViewController.h
//  JKImageCutter
//
//  Created by 蒋鹏 on 17/2/28.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, JKImageCutterType) {
    JKImageCutterTypeRounded = 0, /// 圆角框
    JKImageCutterTypeSquare       /// 矩形框
};

typedef void(^JKImageCutterCompletionHandler)(UIImage * image);






@interface JKImageCutViewController : UIViewController



/**
 裁剪框类型：圆形、正方形
 */
@property (nonatomic, assign) JKImageCutterType type;


/**
 设置需要裁剪的图片和结果回调，无需担心Block导致循环引用

 @param imageSource 需要裁剪的图片
 @param completionHandler 结果回调，返回裁剪后的图片
 */
- (void)cutImage:(UIImage *)imageSource completionHandler:(JKImageCutterCompletionHandler)completionHandler;

@end



@interface UINavigationController (JKImageCutter)

@end

