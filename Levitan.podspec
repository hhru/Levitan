Pod::Spec.new do |spec|
  spec.name = "Levitan"
  spec.version = "1.0.0"
  spec.summary = "A Swift design token system for SwiftUI and UIKit apps with a convenient and compile time safe syntax."

  spec.homepage = "https://github.com/hhru/Levitan"
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { "Almaz Ibragimov" => "almazrafi@gmail.com" }
  spec.source = { :git => "https://github.com/hhru/Levitan.git", :tag => "#{spec.version}" }

  spec.swift_version = '5.7'
  spec.requires_arc = true
  spec.source_files = 'Sources/**/*.swift'

  spec.ios.frameworks = 'Foundation'
  spec.ios.deployment_target = "14.0"

  spec.tvos.frameworks = 'Foundation'
  spec.tvos.deployment_target = "14.0"
end
