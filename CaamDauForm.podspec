
Pod::Spec.new do |s|
  s.name             = 'CaamDauForm'
  s.version          = '2.1.0'
  s.summary          = 'CaamDau 系列产品：流式模型化排版组件.'
  s.description      = <<-DESC
  TODO: CaamDau 系列产品：iOS 便捷开发套件 Swift 版：iOS项目开发通用&非通用型模块代码，多功能组件，可快速集成使用以大幅减少基础工作量；便利性扩展&链式扩展、UI排班组件Form、正则表达式扩展RegEx、计时器管理Timer、简易提示窗HUD、AppDelegate解耦方案、分页控制Page、自定义导航栏TopBar、阿里矢量图标管理IconFonts、MJRefresh扩展、Alamofire扩展......
  附.各种类库使用示例demo.
                       DESC

  s.homepage         = 'https://github.com/CaamDau'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liucaide' => '565726319@qq.com' }
  s.source           = { :git => 'https://github.com/CaamDau/Form.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.swift_version = ['4.0', '4.2', '5.0', '5.1']
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'Form/Core/**/*'
    ss.dependency 'CaamDauExtension'
  end
  
  s.subspec 'Rx' do |ss|
    ss.source_files = 'Form/Rx/**/*'
    ss.dependency 'CaamDauForm/Core'
    ss.dependency 'RxSwift', '5.1.1'
    ss.dependency 'RxCocoa', '5.1.1'
    ss.dependency 'RxDataSources', '4.0.1'
  end
  
  
  s.frameworks = 'UIKit', 'Foundation'
end
