
Pod::Spec.new do |s|

  s.name         = "ECAutoScrollBanner"
  s.version      = "1.0.9"
  s.summary	 = "https://github.com/EchoZuo/ECAutoScrollBanner"
  s.homepage     = "https://github.com/EchoZuo/ECAutoScrollBanner"
  s.license      = "MIT"
  s.author             = { "EchoZuo" => "zuoqianheng@foxmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/EchoZuo/ECAutoScrollBanner.git", :tag => "1.0.9" }
  s.requires_arc = true
  s.source_files = 'ECAutoScrollBanner','ECAutoScrollBanner/YYWebImage', 'ECAutoScrollBanner/YYWebImage/Cache','ECAutoScrollBanner/YYWebImage/Categories', 'ECAutoScrollBanner/YYWebImage/Image'

end

