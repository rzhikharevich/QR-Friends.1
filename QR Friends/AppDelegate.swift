import UIKit
import VKSdkFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, VKSdkDelegate, VKSdkUIDelegate {
    var window: UIWindow?
    
//    var vkAPIKey: String!
    
    var vkSDKInstance: VKSdk!
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(result.state)
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("auth fail")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("vkSdkShouldPresent")
        self.window?.rootViewController?.present(controller, animated: true, completion: {})
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        abort()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        vkSDKInstance = VKSdk.initialize(withAppId: "5758419")
        vkSDKInstance.register(self)
        vkSDKInstance.uiDelegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        if #available(iOS 9.0, *) {
            VKSdk.processOpen(url, fromApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!)
//        } else {
//            VKSdk.processOpen(url, fromApplication: options[UIApplicationOpenURLOptionsKeySourceApplication] as! String!)
//            print("fail")
//        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

