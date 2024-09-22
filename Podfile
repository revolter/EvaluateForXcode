platform :macos, '10.15'

target 'EvaluateForXcode' do
end

target 'SourceEditorExtension' do
    pod 'DDMathParser', git: 'https://github.com/davedelong/DDMathParser', branch: 'master'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.15'
        end
    end
end
