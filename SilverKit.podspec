Pod::Spec.new do |s|

  s.name         = "SilverKit"
  s.version      = "1.1.0"
  s.summary      = "A collection of helpers and handlers, as well as simplified UI elements."

  s.homepage     = "https://github.com/SiLordOfLight/SilverKit"

  s.license      = "MIT"

  s.author    = "Jake Trimble"

  s.platform     = :ios, "12.0"

  s.source       = { :git => "https://github.com/SiLordOfLight/SilverKit.git", :tag => "#{s.version}" }

  s.source_files  = "SilverKit/*.swift"

  s.swift_version = "4.2"

end
