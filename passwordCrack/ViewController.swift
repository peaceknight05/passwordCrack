//
//  ViewController.swift
//  passwordCrack
//
//  Created by Jonathan Tan on 12/8/18.
//  Copyright © 2018 Jonathan Tan. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController {
    
    //MARK: func
    func getTime(string: String) -> Double {
        formatter.dateFormat = "ss.SSSSSS"
        return Double(formatter.string(from: date))!
    }
    
    //MARK: sets
    let NUMBERS = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let LETTERS = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let SPECIALS = ["~", "`", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "-", "+", "=", "{", "}", "[", "]", "|", "\\", ";", ":", "'", "\"", "<", ",", ">", ".", "?", "/"]
    
    //MARK: UI var
    @IBOutlet weak var messageOut: UITextView!
    @IBOutlet weak var crackType: UISegmentedControl!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var timeTake: UILabel!
    
    //MARK: var
    var date = Date()
    var calendar = Calendar.current
    var numIn = "0"
    var letters = 1
    var guessString = ""
    var guessInt = "0"
    var isCounting = false
    var startMinute = 0.0
    var startSecond = 0.0
    var reference = "9"
    var at = 0
    let formatter = DateFormatter()
    var COMMON = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func initCrack(_ sender: Any) {
        if !isCounting {
            date = Date()
            startSecond = getTime(string: "")
            startMinute = Double(Calendar.current.component(.minute, from: date))
            passField.resignFirstResponder()
            messageOut.text! = "initiating cracker\n"
            isCounting = true
            if crackType.selectedSegmentIndex == 0 {
                if Int(passField.text!) == nil {
                    messageOut.text! += "input not valid\n"
                    date = Date()
                    let secondDif = (getTime(string: "") - startSecond)
                    let minDif = ((Double(Calendar.current.component(.minute, from: date)) - startMinute) * 60.0)
                    timeTake.text! = "took \(minDif + secondDif) seconds\n"
                    isCounting = false
                } else {
                    numIn = passField.text!
                    at = 0
                    while at != COMMON.count && guessInt != numIn {
                        if Int(COMMON[at]) != nil {
                            guessInt = COMMON[at]
                            messageOut.text! += "current guess: \(guessInt)\n"
                        }
                        at += 1
                    }
                    if guessInt != numIn {
                        letters = 1
                        guessInt = "0"
                        messageOut.text! += "current guess: 0\n"
                        while guessInt != numIn {
                            reference = ""
                            for _ in 1...letters {
                                reference = "9" + reference
                            }
                            if guessInt != reference {
                                guessInt = String(Int(guessInt)! + 1)
                                while guessInt.count != letters {
                                    guessInt = "0" + guessInt
                                }
                            } else {
                                letters += 1
                                guessInt = ""
                                for _ in 1...letters {
                                    guessInt += "0"
                                }
                            }
                            messageOut.text! += "current guess: \(guessInt)\n"
                        }
                    }
                    messageOut.text! += "cracked\n"
                    date = Date()
                    let secondDif = (getTime(string: "") - startSecond)
                    let minDif = ((Double(Calendar.current.component(.minute, from: date)) - startMinute) * 60.0)
                    timeTake.text! = "took \(minDif + secondDif) seconds\n"
                    isCounting = false
                }
            } else if crackType.selectedSegmentIndex == 1 {
                messageOut.text! += "not implemented"
                isCounting = false
            } else {
                if passField.text! == "" {
                    messageOut.text! += "please input something"
                    date = Date()
                    let secondDif = (getTime(string: "") - startSecond)
                    let minDif = ((Double(Calendar.current.component(.minute, from: date)) - startMinute) * 60.0)
                    timeTake.text! = "took \(minDif + secondDif) seconds\n"
                    isCounting = false
                } else {
                    let context = JSContext()
                    do {
                        guard let path = Bundle.main.path(forResource: "index", ofType: "js") else { return }
                        let script = try String(contentsOfFile: path)
                        context?.evaluateScript(script)
                        let test = context?.objectForKeyedSubscript("start")
                        _ = test?.call(withArguments: [])
                        let loop = context?.objectForKeyedSubscript("loop")
                        let text = passField.text!
                        guard let path2 = Bundle.main.path(forResource: "test", ofType: "txt") else { return }
                        let temp2 = try String(contentsOfFile: path2)
                        let x = loop?.call(withArguments: [text, temp2]).toBool()
                        if x! == true {
                            messageOut.text! += "cracked\n"
                        } else {
                            messageOut.text! += "not cracked\n"
                        }
                        date = Date()
                        let secondDif = (getTime(string: "") - startSecond)
                        let minDif = ((Double(Calendar.current.component(.minute, from: date)) - startMinute) * 60.0)
                        timeTake.text! = "took \((minDif + secondDif).roundTo(places: 2)) seconds\n"
                        isCounting = false
                    } catch {
                    }
                }
            }
        }
    }
    
}

