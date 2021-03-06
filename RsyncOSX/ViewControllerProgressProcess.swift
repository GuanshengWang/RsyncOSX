//
//  ViewControllerProgressProcess.swift
//  RsyncOSXver30
//
//  Created by Thomas Evensen on 24/08/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

//
//  ViewControllerProgress.swift
//  Rsync
//
//  Created by Thomas Evensen on 30/03/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Cocoa


// Protocol for progress indicator
protocol Count: class {
    func maxCount() -> Int
    func inprogressCount() -> Int
}

class ViewControllerProgressProcess: NSViewController {
    
    var count:Double = 0
    var maxcount: Double = 0
    var calculatedNumberOfFiles:Int?
    
    // Delegates
    weak var count_delegate:Count?
    // Dismisser
    weak var dismiss_delegate:DismissViewController?
    
    @IBOutlet weak var progress: NSProgressIndicator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Load protocol functions
        // Dismisser is root controller
        if let pvc = self.presenting as? ViewControllertabMain {
            self.count_delegate = pvc
            self.dismiss_delegate = pvc
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.calculatedNumberOfFiles = self.count_delegate?.maxCount()
        self.initiateProgressbar()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.stopProgressbar()
    }
    
    fileprivate func stopProgressbar() {
        self.progress.stopAnimation(self)
    }
    
    // Progress bars
    private func initiateProgressbar() {
        if let calculatedNumberOfFiles = self.calculatedNumberOfFiles {
            self.progress.maxValue = Double(calculatedNumberOfFiles)
        }
        self.progress.minValue = 0
        self.progress.doubleValue = 0
        self.progress.startAnimation(self)
    }
    
    fileprivate func updateProgressbar(_ value:Double) {
        self.progress.doubleValue = value
    }
    
    
    
}

extension ViewControllerProgressProcess: UpdateProgress {
    
    // Protocol UpdateProgress
    
    func ProcessTermination() {
        self.stopProgressbar()
        self.dismiss_delegate?.dismiss_view(viewcontroller: self)
    }
    
    func FileHandler() {
        self.updateProgressbar(Double(self.count_delegate!.inprogressCount()))
    }

    
}
