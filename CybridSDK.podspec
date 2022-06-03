Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "CybridSDK"
  spec.version      = "0.0.1"
  spec.summary      = "Cybrid iOS SDK"

  spec.description  = <<-DESC
    CybridSDK is a Framework that provides fast integration to Cybrid Services through reusable UI components.
                   DESC

  spec.homepage     = "https://github.com/Cybrid-app/cybrid-sdk-ios"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = { :type => 'Apache-2.0', :file => 'LICENSE' }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.author             = "Cybrid Technology Inc."

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.platform     = :ios, "13.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source       = { :git => "https://github.com/Cybrid-app/cybrid-sdk-ios.git", :tag => "#{spec.version}" }
  
  # ――― Dependencies ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # spec.dependency "SnapKit", "~> 5.0"

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source_files  = "CybridSDK/**/*.{swift,h,m}"
  
  # spec.exclude_files = "Classes/Exclude"
  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  # spec.resource_bundles = { "Classes/**/*.{storyboard,xib,json,otf,ttf,strings,xcassets}" }

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.pod_target_xcconfig = {
      "BITCODE_GENERATION_MODE" => "bitcode",
      "BUILD_LIBRARY_FOR_DISTRIBUTION" => "YES"
  }

end
