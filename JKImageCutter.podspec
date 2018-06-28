#
#  Be sure to run `pod spec lint JKImageCutter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "JKImageCutter"
  s.version      = "1.0.0"
  s.summary      = "通用型的图片裁剪器，支持圆形和方形裁剪，对长图、小图都有做兼容优化。"
  s.homepage     = "https://github.com/XiFengLang/JKImageCutter"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "XiFengLang" => "lang131jp@vip.qq.com" }

  s.source       = { :git => "https://github.com/XiFengLang/JKImageCutter.git", :tag => "#{s.version}" }

  s.source_files  = "JKImageCutter/*.{h,m}"

  s.resources = "JKImageCutter/*.png"


  s.framework  = "UIKit"
 

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
