//
//  Resources.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 20/12/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation

// Enumtype type of resource
enum resourceType {
    case changelog
    case documents
    case urlPlist
}

struct Resources {
    // Resource strings
    private var changelog: String = "https://rsyncosx.github.io/Documentation/docs/Changelog.html"
    private var documents: String = "https://rsyncosx.github.io/Documentation/"
    private var urlPlist: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncOSX/master/versionRsyncOSX/versionRsyncOSX.plist"
    // Get the resource.
    func getResource (resource: resourceType) -> String {
        switch resource {
        case .changelog:
            return self.changelog
        case .documents:
            return self.documents
        case .urlPlist:
            return self.urlPlist
        }
    }
    
}
