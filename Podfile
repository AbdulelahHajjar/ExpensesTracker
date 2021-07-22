plugin "cocoapods-binary-cache"
platform :ios, '13.0'

config_cocoapods_binary_cache(
  device_build_enabled: true,
  cache_repo: {
    "default" => {
      "remote" => "https://github.com/AbdulelahHajjar/ExpensesTracker-Prebuilt-Pods.git",
      "local" => "~/Developer/prebuilt-frameworks/ExpensesTracker-Prebuilt-Pods"
    }
  }
)

target 'ExpensesTracker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ExpensesTracker
  pod "Firebase/Auth", :binary => true
  pod "Firebase/Firestore", :binary => true
  pod "FirebaseFirestoreSwift", :binary => false

end