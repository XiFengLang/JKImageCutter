#
#  Be sure to run `pod spec lint JKImageCutter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "JKImageCutter"
  s.version      = "1.0.2"
  s.summary      = "通用型的图片裁剪器，支持圆形和方形裁剪，对长图、小图都有做兼容优化。"
  s.homepage     = "https://github.com/XiFengLang/JKImageCutter"
  
  s.license      = "MIT"
  s.author       = { "XiFengLang" => "lang131jp@vip.qq.com" }
  s.source       = { :git => "https://github.com/XiFengLang/JKImageCutter.git", :tag => "#{s.version}" }

  s.source_files  = "JKImageCutter/*.{h,m}"
  s.resources = "JKImageCutter/JKImageCutter.bundle"

  s.platform     = :ios,"8.0"
  s.framework  = "UIKit"
  s.requires_arc = true

end
