Pod::Spec.new do |spec|

  spec.name         = "PainlessInjection"
  spec.version      = "1.7.0"
  spec.summary      = "PainlessInjection is a lightweight dependency injection framework for Swift."

  spec.description  = <<-DESC
  PainlessInjection is a lightweight dependency injection framework for Swift. Thanks.
                   DESC

  spec.homepage     = "https://github.com/yaroslav-zhurakovskiy/PainlessInjection"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "yaroslav-zhurakovskiy" => "yaroslav.zhurakovskiy@gmail.com" }

  spec.platform     = :ios, "8.0"
  spec.requires_arc = true
  spec.swift_version = '5.1'

  spec.source       = {
    :git => "https://github.com/yaroslav-zhurakovskiy/PainlessInjection.git",
    :tag => "v" + spec.version.to_s
  }

  spec.source_files = "Source/*.swift"

end
