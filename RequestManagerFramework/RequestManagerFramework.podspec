

Pod::Spec.new do |s|

  s.name         = "RequestManagerFramework"
  s.version      = "1.0.0"
  s.summary      = "This is a RequestManagerFramework"
  s.description  = "This framework is for making a service request and performs CRUD operations."
  s.homepage     = "https://github.com/vishalmodem/RequestManagerFramework"
  s.license      = "MIT"
  s.author       = { "Vishal Modem" => "vishal.modem@gmail.com" }
  s.platform     = :ios, "11.4"
  s.source       = { :git => "https://github.com/vishalmodem/RequestManagerFramework.git", :tag => "1.0.0" }
  s.source_files  = "RequestManagerFramework/**/*"
  s.swift_version = '4.1'
end
