Pod::Spec.new do |s|

  s.name         = "PainlessInjection"
  s.version      = "0.0.2"
  s.summary      = "PainlessInjection is a lightweight dependency injection framework for Swift."

  s.description  = <<-DESC
  PainlessInjection is a lightweight dependency injection framework for Swift. Thanks.
                   DESC

  s.homepage     = "https://github.com/yaroslav-zhurakovskiy/PainlessInjection"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "yaroslav-zhurakovskiy" => "yaroslav.zhurakovskiy@gmail.com" }

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/yaroslav-zhurakovskiy/PainlessInjection.git", :branch => "master", :tag => s.version.to_s }

  s.source_files  = "PainlessInjection/PainlessInjection/*.swift"

end
