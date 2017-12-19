
Pod::Spec.new do |s|

s.name  	= "ECAutoScrollBanner"
s.version 	= "1.0.1"
s.summary 	= "轮播图封装。可以实现自动定时翻页、手动翻页；垂直和水平滚动等。支持纯文本、本地图片、网络图片以及其他view试图。
s.homepage 	= "https://github.com/EchoZuo/ECAutoScrollBanner"
s.license 	= "MIT"
s.author 	= {"Echo Zup" => "zuoqianheng@foxmail.com" }
s.platform      = :ios, "7.0"
s.source 	= { :git => "https://github.com/EchoZuo/ECAutoScrollBanner", :tag => "1.0.1" }
s.requires_arc	= true
s.source_files 	= "ECAutoScrollBanner/*.{h,m}"

end
