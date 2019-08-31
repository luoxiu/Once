Pod::Spec.new do |s|
  s.name         = "Once"
  s.version      = "1.0.0"
  s.summary      = "Once allows you to manage the number of executions of a task using an intuitive API."
  s.homepage     = "https://github.com/luoxiu/Once"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Quentin Jin" => "luoxiustm@gmail.com" }
  s.source       = { :git => "https://github.com/luoxiu/Once.git", :tag => s.version.to_s }
  s.source_files     = "Sources/**/*"
  s.swift_version    = "5.0"

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"
end
