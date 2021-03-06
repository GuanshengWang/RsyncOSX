//
//  processCmd.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 10.03.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//

import Foundation

class processCmd {
    
    // Number of calculated files to be copied
    var calculatedNumberOfFiles:Int = 0
    // Variable for reference to Process
    var ProcessReference:Process?
    // Message to calling class
    weak var delegate_update:UpdateProgress?
    // If process is created in Operation
    var aScheduledOperation:Bool?
    // Observer
    weak var observationCenter: NSObjectProtocol?
    // Command to be executed, normally rsync
    var command:String?
    // Arguments to command
    var arguments:Array<String>?
    
    func executeProcess (output:outputProcess){
        // Process
        let task = Process()
        // Setting the correct path for rsync
        // If self.command != nil other command than rsync to be executed
        // Other commands are either ssh or scp (from CopyFiles)
        if let command = self.command {
            task.launchPath = command
        } else {
            task.launchPath = SharingManagerConfiguration.sharedInstance.setRsyncCommand()
        }
        task.arguments = self.arguments
        // Pipe for reading output from Process
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        
        // Observator for reading data from pipe
        // Observer is removed when Process terminates
        self.observationCenter = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: nil, queue: nil)
        { notification -> Void in
            let data = outHandle.availableData
            if data.count > 0 {
                if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    // Add files to be copied, the output.addString takes care of
                    // splitting the output
                    output.addLine(str as String)
                    self.calculatedNumberOfFiles = output.getOutputCount()
                    // Check if in a scheduled operation, if not use delegate to inform about progress
                    if (self.aScheduledOperation! == false) {
                        // Send message about files
                        self.delegate_update?.FileHandler()
                    }
                }
                outHandle.waitForDataInBackgroundAndNotify()
            }
        }
        // Observator Process termination
        // Observer is removed when Process terminates
        self.observationCenter = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil)
        { notification -> Void in
            // Collectiong numbers in output
            // Forcing a --stats in dryrun which produces a summarized detail about
            // files and bytes. getNumbers collects that info and store the result in the
            // object.
            output.setNumbers()
             // Check if in a scheduled operation, if not use delegate to inform about termination of Process()
            if (self.aScheduledOperation! == false) {
                // Send message about process termination
                self.delegate_update?.ProcessTermination()
            } else {
                // We are in Scheduled operation and must finalize the job
                // e.g logging date and stuff like that
                if (SharingManagerConfiguration.sharedInstance.operation != nil) {
                    SharingManagerConfiguration.sharedInstance.operation!.finalizeScheduledJob(output: output)
                }
                // After logging is done set reference to object = nil
                SharingManagerConfiguration.sharedInstance.operation = nil
            }
            NotificationCenter.default.removeObserver(self.observationCenter as Any)
        }
        
        self.ProcessReference = task
        task.launch()
    }
    
    func getProcess() -> Process? {
        return self.ProcessReference
    }
    
    func abortProcess() {
        if self.ProcessReference != nil {
            self.ProcessReference!.terminate()
        }
    }
    
}

