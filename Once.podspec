Pod::Spec.new do |s|
  s.name         = "Once"
  s.version      = "0.0.1"
  s.summary      = "Minimalists library to manage one-off operations."
  s.description  = <<-DESC
    Once is a minimalists library to manage one-off operations. 
  DESC
  s.homepage     = "https://github.com/jianstm/Once"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Quentin Jin" => "jianstm@gmail.com" }
  s.source       = { :git => "https://github.com/jianstm/Once.git", :tag => s.version.to_s }
  s.source_files     = "Sources/**/*"
  s.frameworks       = "Foundation"
  s.requires_arc     = true
  s.swift_version    = "4.2"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
end
