Pod::Spec.new do |s|
  s.name         = "WTMSCEngine"
  s.version      = "0.0.5"
  s.summary      = "WTMSCEngine MSC组建"

  s.homepage     = "https://github.com/aliang666/WTMSCEngine"

  s.license      = "MIT"
  s.author             = { "jienliang000" => "jienliang000@163.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/aliang666/WTMSCEngine.git", :tag => "#{s.version}" }
  s.source_files  = "WTMSCEngine/*.{h,m,framework}"

end
