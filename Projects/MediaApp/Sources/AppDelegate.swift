//
//  AppDelegate.swift
//  MediaApp
//
//  Created by DOYEON LEE on 7/6/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Kingfisher 설정
        KingfisherConfig.setup()
        return true
    }
}
