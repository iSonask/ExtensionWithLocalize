//
//  AppDelegate.swift
//  AK
//
//  Created by SHANI SHAH on 22/11/18.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var clGeocoder: CLGeocoder?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Localize.availableLanguages())
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        // Here you can check whether you have allowed the permission or not.
        Thread.sleep(forTimeInterval: 3.9)
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()//(locationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
                
                CLGeocoder().reverseGeocodeLocation(locations.last!) { placemarks, error in
                    print(placemarks?.first?.locality!,
                               placemarks?.first?.country!)
                    let country = placemarks?.first!.country
                    if country == "India"{
                        Localize.setCurrentLanguage("Base")
                    } else {
                        Localize.setCurrentLanguage("es")
                    }
                }
                break
            case .notDetermined:
                print("Not determined.")
                self.showAlertMessage(messageTitle: "AK", withMessage: "Location service is disabled!!")
                break
                
            case .restricted:
                print("Restricted.")
                self.showAlertMessage(messageTitle: "AK", withMessage: "Location service is disabled!!")
                break
                
            case .denied:
                print("Denied.")
            }
        }
    }
    
    func showAlertMessage(messageTitle: NSString, withMessage: NSString) ->Void  {
        let alertController = UIAlertController(title: messageTitle as String, message: withMessage as String, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction!) in
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/com.company.AppName") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        alertController.addAction(OKAction)
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

