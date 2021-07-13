//
//  SceneDelegate.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 04/06/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let hmmcenter = UNUserNotificationCenter.current()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        UIApplication.shared.applicationIconBadgeNumber =  0
        hmmcenter.removeAllDeliveredNotifications()
//        hmmcenter.removeAllPendingNotificationRequests()
        

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber =  0

        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
//        let center = UNUserNotificationCenter.current()

        let leftoverPower = UserDefUtils.userPurchasedPower - UserDefUtils.userConsumptionPower 
        if leftoverPower < UserDefUtils.userThresholdPower{
    
            let content = UNMutableNotificationContent()
            content.title = "Exceeded Power Limit! 😮"
            content.body = "Ibukunoluwa, you have used up too much power, consider buying more immediately "
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.defaultCritical
    
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
    
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UIApplication.shared.applicationIconBadgeNumber += 1
            hmmcenter.add(request)
        }
        
        
        hmmcenter.add(generateDailyNotification())
//        UIApplication.shared.applicationIconBadgeNumber += 1
                
    }

    fileprivate func generateDailyNotification() -> UNNotificationRequest{
        let content = UNMutableNotificationContent()
        content.title = "Today's Power Consumption 💡"
        content.body = "Ibukunoluwa, you have used up \(String(format: "%.2f", UserDefUtils.userConsumptionPower)) kwH today"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.defaultCritical
        
        var dateComponents = DateComponents()
        dateComponents.hour = 02
        dateComponents.minute = 18
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        return request
    }

}

