//
//  AppDelegate.swift
//  RsyncOSXver30
//
//  Created by Thomas Evensen on 18/08/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Check for new version
        _ = newVersion()
        
        // Read user configuration
        if let userConfiguration =  persistentStoreAPI.sharedInstance.getUserconfiguration() {
            // userConfiguration is never nil if object is created
            _ = userconfiguration(userconfigRsyncOSX: userConfiguration)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

