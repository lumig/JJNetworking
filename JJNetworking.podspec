Pod::Spec.new do |s|
  s.name         = "JJNetworking"
  s.version      = "1.0"
  s.summary      = "一个去model化的AFNetworking的封装"
  s.homepage     = "https://github.com/lumig"
  s.license      = "MIT"
  s.author       = { "lumig" => "lumic@sina.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/lumig/JJNetworking.git", :tag => "#{s.version}" }
  s.source_files  = "JJNetworking/JJNetworking/**/*.{h,m}"
  s.requires_arc = true
  # s.exclude_files = "Classes/Exclude"
  s.dependency 'AFNetworking'
  s.dependency 'RealReachability'
  s.dependency 'YYKit'


end