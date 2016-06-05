Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name = "KMSegmentedControl"
  s.summary = "KMSegmentedControl let's you customize your UISegmentedControl as you prefer."
  s.requires_arc = true
  s.version = "1.0.2"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Kamil Mazurek" => "kamilm@outlook.de" }
  s.homepage = "https://github.com/YounZ/KMSegmentedControl"
  s.source = { :git => "https://github.com/YounZ/KMSegmentedControl.git", :tag => "#{s.version}"}
  s.framework = "UIKit"
  s.source_files = "KMSegmentedControl/**/*.{swift}"
end
