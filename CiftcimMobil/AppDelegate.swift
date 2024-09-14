

import UIKit
import CoreData
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        /*Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        if let authSettings = Auth.auth().settings {
            print("App verification settings: \(authSettings)")
        } else {
            print("App verification settings are not available.")
        }*/
        // CoreDataStack'in shared instance'ını başlat

        
                _ = CoreDataStack.shared
        CampaignService.shared.addDefaultCampaigns()
        CampaignService.shared.addDefaultOrganizations()
        
        let darkGreenColor = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = darkGreenColor
            
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            // Geri butonunun rengini beyaz yap
            UINavigationBar.appearance().tintColor = UIColor.white
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            } else {
                // iOS 13 öncesi
                UINavigationBar.appearance().barTintColor = darkGreenColor
        }
        UITabBar.appearance().tintColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
    }
    
   
}

