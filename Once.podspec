Pod::Spec.new do |s|
  s.name         = "Once"
  s.version      = "1.0.0"
  s.summary      = "Minimalists library to manage one-off operations."
  s.description  = <<-DESC
    Once is a minimalists library to manage one-off operations. 
  DESC
  s.homepage     = "https://github.com/luoxiu/Once"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Quentin Jin" => "luoxiustm@gmail.com" }
  s.source       = { :git => "https://github.com/luoxiu/Once.git", :tag => s.version.to_s }
  s.source_files     = "Sources/**/*"
  s.frameworks       = "Foundation"
  s.requires_arc     = true
  s.swift_version    = "5.0"

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"
end
