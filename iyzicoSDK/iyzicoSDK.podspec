Pod::Spec.new do |s|

  s.name         = "iyzicoSDK"
  s.version      = "1.0.0"
  s.summary      = "iyzico’nun güvenli ve kolay ödeme hizmetleri yer alır."
  s.description  = <<-DESC
		   iyzico'nun güvenli ve kolay ödeme yöntemi olan Pay with iyzico ürününü, 		   müşterilerin bakiyelerine yükleme yapmak için kullanabilecekleri Top-up 		   ürününü ve hediye puanlarını bakiyelerine alabilecekleri Cash-out 			   ürününü içermektedir
                   DESC

  s.homepage     = "https://github.com/iyzico/iyzico-podspecs"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "iyzico" => "integration@iyzico.com" } 
  s.ios.deployment_target = '12.0'
  s.ios.vendored_frameworks = 'iyzicoSDK.framework'
  s.source        = { :git => 'https://github.com/iyzico/iyzico-podspecs.git',
			 :tag => s.version.to_s
		 	}
  s.swift_version = '5.0'
  s.exclude_files = "Classes/Exclude"

  s.dependency 'Alamofire', '~> 5.4.1'
  s.dependency 'IQKeyboardManagerSwift', '~> 6.5.6'
  s.dependency 'lottie-ios', '~> 3.2.1'
  s.dependency 'SVGKit', '~> 3.0.0'
  s.dependency 'CocoaLumberjack/Core', '~> 3.7.2'

 s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end