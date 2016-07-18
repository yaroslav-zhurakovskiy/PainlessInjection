Pod::Spec.new do |s|

  s.name         = "PainlessInjection"
  s.version      = "0.0.1"
  s.summary      = "PainlessInjection is a lightweight dependency injection framework for Swift."

  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/yaroslav-zhurakovskiy/PainlessInjection"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "yaroslav-zhurakovskiy" => "yaroslav.zhurakovskiy@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/yaroslav-zhurakovskiy/PainlessInjection.git"}

  s.source_files  = "PainlessInjection",
                    "PainlessInjection/**/*.swift",
                    "PainlessInjectionLoader",
                    "PainlessInjectionLoader/**/*.{h,m}"

  s.requires_arc = true

end
