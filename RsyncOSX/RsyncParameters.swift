//
//  RsyncParameters.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 03/10/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation

final class RsyncParameters {
    
    // Tuple for rsync argument and value
    typealias argument = (String , Int)
    // Static initial arguments, DO NOT change order
    private let rsyncArguments:Array<argument> = [
        ("user",1),
        ("delete",0),
        ("--stats",0),
        ("--backup",0),
        ("--backup-dir",1),
        ("--exclude-from",1),
        ("--include-from",1),
        ("--files-from",1),
        ("--max-size",1),
        ("--suffix",1)]
    
    // Preselected parameters for storing a backup of deleted or changed files before
    // rsync synchronises the directories
    private let backupString = ["--backup","--backup-dir=../backup"]
    private let suffixString = ["--suffix=_`date +'%Y-%m-%d.%H.%M'`"]
    private let suffixString2 = ["--suffix=_$(date +%Y-%m-%d.%H.%M)"]

    /// Function for getting string for backup parameters
    /// - parameter none: none
    /// - return : array of String
    func getBackupString() -> Array<String> {
        return self.backupString
    }
    
    /// Function for getting string for suffix parameter
    /// - parameter none: none
    /// - return : array of String
    func getSuffixString() -> Array<String> {
        return self.suffixString
    }
    
    /// Function for getting string for alternative suffix parameter
    /// - parameter none: none
    /// - return : array of String
    func getSuffixString2() -> Array<String> {
        return self.suffixString2
    }

    /// Function for getting for rsync arguments to use in ComboBoxes in ViewControllerRsyncParameters
    /// - parameter none: none
    /// - return : array of String
    func getComboBoxValues() -> Array<String> {
        var values = Array<String>()
        for i in 0 ..< self.rsyncArguments.count {
            values.append(self.rsyncArguments[i].0)
        }
        return values
    }
    
    // Computes the raw argument for rsync to save in configuration
    /// Function for computing the raw argument for rsync to save in configuration
    /// - parameter indexComboBox: index of selected ComboBox
    /// - parameter value: the value of rsync parameter
    /// - return: array of String
    func getRsyncParameter (indexComboBox:Int, value:String?) -> String {
        guard  indexComboBox < self.rsyncArguments.count && indexComboBox > -1 else {
            return ""
        }
        switch (self.rsyncArguments[indexComboBox].1) {
        case 0:
            // Predefined rsync argument from combobox
            // Must check if DELETE is selected
            if self.rsyncArguments[indexComboBox].0 == self.rsyncArguments[1].0 {
                return ""
            } else {
                return  self.rsyncArguments[indexComboBox].0
            }
        case 1:
            // If value == nil value is deleted and return empty string
            guard value != nil else {
                return ""
            }
            if self.rsyncArguments[indexComboBox].0 != self.rsyncArguments[0].0 {
                return self.rsyncArguments[indexComboBox].0 + "=" + value!
            } else {
                // Userselected argument and value
                return value!
            }
        default:
            return  ""
        }
    }
    
    
    // Returns Int value of argument
    private func indexValue (_ argument:String) -> Int {
        var index:Int = -1
        loop : for i in 0 ..< self.rsyncArguments.count {
            if argument == self.rsyncArguments[i].0 {
                index = i
                break loop
            }
        }
        return index
    }
    
    // Split an Rsync argument into argument and value
    private func split (_ str:String) -> Array<String> {
        let argument:String?
        let value:String?
        var split = str.components(separatedBy: "=")
        argument = String(split[0])
        if split.count > 1 {
            value = String(split[1])
        } else {
            value = argument
        }
        return [argument!,value!]
    }
    
    // Get the rsync parameter to store in the configuration.
    // Function computes which parameters are arguments only 
    // e.g --backup, or --suffix=value.
    func getdisplayValue (_ parameter:String) -> String {
        let splitstr:Array<String> = self.split(parameter)
        guard splitstr.count > 1 else {
            return ""
        }
        let argument = splitstr[0]
        let value = splitstr[1]
        if (argument != value && self.indexValue(argument) >= 0)  {
            return value
        } else {
            if self.indexValue(splitstr[0]) >= 0 {
                return "\"" + argument + "\" " + "no arguments"
            } else {
                guard (argument != value) else {
                    return value
                }
                return argument + "=" + value
            }
        }
    }
    
    /// Function returns value of rsync argument to set the corrospending
    /// value in combobox when rsync parameters are presented
    /// - parameter parameter : Stringvalue of parameter
    /// - returns : index of parameter
    func getvalueCombobox (_ parameter:String) -> Int {
        let splitstr:Array<String> = self.split(parameter)
        guard splitstr.count > 1 else {
            return 0
        }
        let argument = splitstr[0]
        let value = splitstr[1]
        if (argument != value && self.indexValue(argument) >= 0)  {
            return self.indexValue(argument)
        } else {
            guard self.indexValue(splitstr[0]) >= 0 else {
                return 0
            }
            return self.indexValue(argument)
        }
    }

    /// Function returns value of rsync a touple to set the corrospending
    /// value in combobox and the corrosponding rsync value when rsync parameters are presented
    /// - parameter config : a configuration
    /// - parameter rsyncparameternumber : which stored rsync parameter, integer 8 - 14
    /// - returns : touple with index to for combobox and corresponding rsync value
    func getParameter (config:configuration, rsyncparameternumber:Int) -> (Int, String) {
        
        var value:(Int,String)?
        
        switch rsyncparameternumber {
        case 8:
            guard config.parameter8 != nil else {
                return (0,"")
            }
            value = (self.getvalueCombobox(config.parameter8!), self.getdisplayValue(config.parameter8!))
        case 9:
            guard config.parameter9 != nil else {
                return (0,"")
            }
            value = (self.getvalueCombobox(config.parameter9!), self.getdisplayValue(config.parameter9!))
        case 10:
            guard config.parameter10 != nil else {
                return (0,"")
            }
            value = (self.getvalueCombobox(config.parameter10!), self.getdisplayValue(config.parameter10!))
        case 11:
            guard config.parameter11 != nil else {
                return (0,"")
            }
            value = (self.getvalueCombobox(config.parameter11!), self.getdisplayValue(config.parameter11!))
        case 12:
            guard config.parameter12 != nil else {
                return (0,"")
            }
            value = (self.getvalueCombobox(config.parameter12!), self.getdisplayValue(config.parameter12!))
        case 13:
            guard config.parameter13 != nil else {
                return (0,"")
            }
            value = (self.getvalueCombobox(config.parameter13!), self.getdisplayValue(config.parameter13!))
        case 14:
            guard config.parameter14 != nil else {
                return (0,"")
            }
            value = (self.getvalueCombobox(config.parameter14!), self.getdisplayValue(config.parameter14!))
        default:
            value = (0,"")
        }
        return value!
    }
}
