# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

def common_install
  pod 'SnapKit', '5.7.1'
end

target 'ChannelA' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ChannelA
  common_install
end

target 'ChannelB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ChannelB
  common_install

end

#post_install do |installer|
#  # 直接查找 Pods 生成的 Pod.xcconfig
#    pod_xcconfig_paths = Dir.glob("Pods/Target Support Files/Pods-*/*.xcconfig")
#
#  # 获取所有 Pods 生成的 .xcconfig 文件
#    custom_xcconfig_paths = Dir.glob("Shared/*.xcconfig")
#    
#    puts "\n🚀 生成的 Pod.xcconfig 文件路径："
#    pod_xcconfig_paths.each { |path| puts "📄 #{path}" }
#    
#    puts "\n🚀 自定义的 custom.xcconfig 文件路径："
#    custom_xcconfig_paths.each { |path| puts "📄 #{path}" }
#end

post_install do |installer|
  project = Xcodeproj::Project.open("mutiple_channel_demo.xcodeproj")
  
  # 遍历所有目标
  project.targets.each do |target|
    target.build_configurations.each do |config|
      # 获取 Pods 生成的 xcconfig 文件路径
      pods_xcconfig = "Pods/Target Support Files/Pods-#{target.name}/Pods-#{target.name}.#{config.name.downcase}.xcconfig"
      
      # 创建或更新自定义的 xcconfig 文件
      custom_xcconfig = "Shared/Custom-#{target.name}-#{config.name}.xcconfig"
      
      # 确保自定义配置文件目录存在
      FileUtils.mkdir_p(File.dirname(custom_xcconfig))
      
      # 如果自定义配置文件不存在，创建它
      unless File.exist?(custom_xcconfig)
        File.write(custom_xcconfig, "#include \"#{pods_xcconfig}\"\n\n# 自定义配置\n")
        custom_xcconfig_ref = project.new_file(custom_xcconfig)
      end
      
      # 在项目中找到或创建对应的文件引用
      custom_xcconfig_ref = project.files.find { |f| f.path == custom_xcconfig }
      if custom_xcconfig_ref.nil?
        custom_xcconfig_ref = project.new_file(custom_xcconfig)
      end
      
      puts "📄 #{custom_xcconfig_ref}"
      # 将配置关联到对应的 target
      config.base_configuration_reference = custom_xcconfig_ref
    end
  end
  
  project.save
end


