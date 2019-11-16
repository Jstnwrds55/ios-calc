//
//  ViewController.swift
//  Calculator
//
//  Created by Justin on 5/30/19.
//  Copyright © 2019 Justin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    // darker rgb (red: 0.7411764706, green: 0.3411764706, blue: 0.3215686275, alpha: 1.0)
    // lighter rgb (red: 0.8823529412, green: 0.4078431373, blue: 0.3764705882, alpha: 1.0)
    
    // num displays
    @IBOutlet weak var calculatorNumDisplay: UILabel!
    @IBOutlet weak var calculatorPreviousDisplay1: UILabel!
    @IBOutlet weak var calculatorPreviousDisplay2: UILabel!
    
    // state variables
    var calculatorState: String = "left"
    var clearNow: Bool = false
    var newCalculation: Bool = false
    var operatorAfterCalculation = false
    
    // calculation variables
    var leftOperandString = String()
    var rightOperandString = String()
    var leftOperand: Double? = nil
    var rightOperand: Double? = nil
    var calculatorOperator = String()
    var operatorButton: UIButton? = nil
    
    // number or decimal pressed
    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        // if new calculation after equalling last one
        if (newCalculation) {
            
            // remove previous result from left operand and reset state
            leftOperandString = ""
        }
        
        if (operatorAfterCalculation) {
            rightOperandString = sender.currentTitle!
            operatorAfterCalculation = false
            calculatorState = "right"
            updateDisplay(stringToDisplay: rightOperandString)
        
        // inputting left operand
        } else if (calculatorState == "left") {
            
            // add button pressed to left operand string
            leftOperandString += sender.currentTitle!
            print("left: \(leftOperandString)")
            // if a second decimal was pressed, remove it
            if (sender.currentTitle == ".") {
                if (leftOperandString.lastIndex(of: ".") != nil && leftOperandString.firstIndex(of: ".") != leftOperandString.lastIndex(of: ".")) {
                    leftOperandString.removeLast()
                }
            }
            
            updateDisplay(stringToDisplay: leftOperandString)
            
        // operator set, inputting right operand
        } else if (calculatorState == "operator") {
            
            // add button pressed to right operand string
            rightOperandString += sender.currentTitle!
            print("right: \(rightOperandString)")
            // if a second decimal was pressed, remove it
            if (sender.currentTitle == ".") {
                if (rightOperandString.lastIndex(of: ".") != nil && rightOperandString.firstIndex(of: ".") != rightOperandString.lastIndex(of: ".")) {
                    rightOperandString.removeLast()
                }
            }
            
            updateDisplay(stringToDisplay: rightOperandString)
            
            calculatorState = "right" // set calculator state
            
        // inputting right operand
        } else if (calculatorState == "right") {
            
            // add button pressed to right operand string
            rightOperandString += sender.currentTitle!
            
            // if a second decimal was pressed, remove it
            if (sender.currentTitle == ".") {
                if (rightOperandString.lastIndex(of: ".") != nil && rightOperandString.firstIndex(of: ".") != rightOperandString.lastIndex(of: ".")) {
                    rightOperandString.removeLast()
                }
            }
            
            updateDisplay(stringToDisplay: rightOperandString)
        }
        
        // if the operator button exists it will reset to regular red
        if (operatorButton != nil) {
            operatorButton!.backgroundColor = UIColor(red: 0.8823529412, green: 0.4078431373, blue: 0.3764705882, alpha: 1.0)
        }
        
        newCalculation = false
        
    }
    
    // any of the 4 operator buttons pressed
    @IBAction func operatorButtonPressed(_ sender: UIButton) {
        
//        // if they use the minus sign as a negative
//        if (sender.currentTitle == "-") {
//            if (calculatorState == "left" && leftOperandString == "") {
//                leftOperandString += "-"
//                updateDisplay(stringToDisplay: leftOperandString)
//            } else if ((calculatorState == "operator" || calculatorState == "right") && rightOperandString == "") {
//                rightOperandString += "-"
//                updateDisplay(stringToDisplay: rightOperandString)
//            }
//        }
        
        // operator pressed after left operand set
        if (calculatorState == "left" && leftOperandString != "") {
            
            // store left operand as Double and reset string
            leftOperand = Double(leftOperandString)!
            leftOperandString = ""
            calculatorOperator = sender.currentTitle! // store operator
            calculatorState = "operator" // set calculator state
            
            // store button for setting color and set color
            operatorButton = sender
            operatorButton!.backgroundColor = UIColor(red: 0.7411764706, green: 0.3411764706, blue: 0.3215686275, alpha: 1.0)
           
        // operator changed
        } else if (calculatorState == "operator") {
            
            calculatorOperator = sender.currentTitle! // store new operator
            operatorAfterCalculation = true
            
            // reset color of previous operator and set new one
            operatorButton!.backgroundColor = UIColor(red: 0.8823529412, green: 0.4078431373, blue: 0.3764705882, alpha: 1.0)
            operatorButton = sender
            operatorButton!.backgroundColor = UIColor(red: 0.7411764706, green: 0.3411764706, blue: 0.3215686275, alpha: 1.0)
        
        // right operand set, perform calculation, display result, set operator
        } else if (calculatorState == "right") {
            
            // calculate and set new operator
            calculate()
            calculatorOperator = sender.currentTitle! // store operator
            operatorAfterCalculation = true
            
            // set calculator state and change operator color
            calculatorState = "operator"
            operatorButton = sender
            operatorButton!.backgroundColor = UIColor(red: 0.7411764706, green: 0.3411764706, blue: 0.3215686275, alpha: 1.0)
            
        }
        
    }
    
    // equal button pressed
    @IBAction func equalButtonPressed(_ sender: UIButton) {
        
        // if left and right operand have both been set
        if (leftOperand != nil && rightOperandString != "") {
            calculate()
            calculatorState = "left"
            rightOperandString = ""
        }
        newCalculation = true // this is for next calculation, check numpressed func
    }
    
    // +/- button pressed, just changes the operand to positive or negative.
    @IBAction func negativeButtonPressed(_ sender: UIButton) {
        
        // if it's on the left operand
        if (calculatorState == "left") {
            
            // negative -> positive
            if (leftOperandString.first == "-") {
                leftOperandString.remove(at: leftOperandString.startIndex)
                
            // positive -> negative
            // with decimal
            } else if (leftOperandString.prefix(2) == "0.") {
               leftOperandString = "-0."
                
            // no decimal
            } else {
                leftOperandString = "-" + leftOperandString
            }
            
            updateDisplay(stringToDisplay: leftOperandString)
            
        // on the operator or right operand
        } else {
            
            // negative -> positive
            if (rightOperandString.first == "-") {
                rightOperandString.remove(at: rightOperandString.startIndex)
                
            // positive -> negative
                
            // with decimal
            } else if (rightOperandString.prefix(2) == "0.") {
                rightOperandString = "-.0"
                
            // no decimal
            } else {
                rightOperandString = "-" + rightOperandString
            }
            
            updateDisplay(stringToDisplay: rightOperandString)
        }
    }
    
    // AC button pressed
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
        // if AC has already been pressed and clearNow is set
        if (clearNow) {
            
            // clear everything and reset calculator state
            leftOperand = nil
            leftOperandString = ""
            calculatorState = "left"
            clearNow = false
            operatorButton!.backgroundColor = UIColor(red: 0.8823529412, green: 0.4078431373, blue: 0.3764705882, alpha: 1.0)
            
        // if on left operand and left operand contains something
        } else if (calculatorState == "left" && leftOperandString != "") {
            
            // reset left operand and display
            leftOperandString = ""
            calculatorNumDisplay.text = "0"
            
        // if on operator
        } else if (calculatorState == "operator" || calculatorState == "right") {
            
            // reset right operand and display
            rightOperandString = ""
            calculatorNumDisplay.text = "0"
            clearNow = true // next press of AC will reset calculation entirely
            
            // if it's on right operand darken operator again
            if (calculatorState == "right") {
                operatorButton!.backgroundColor = UIColor(red: 0.7411764706, green: 0.3411764706, blue: 0.3215686275, alpha: 1.0)
            }
        }
    }
    
    // percentage button pressed
    @IBAction func percentButtonPressed(_ sender: UIButton) {
        
        // if the user hasn't only put a decimal or minus sign
        if (calculatorNumDisplay.text != "." || calculatorNumDisplay.text != "-") {
            // get the current string displayed and convert to double
            var stringDisplay: String = calculatorNumDisplay.text!
            var doubleDisplay: Double = Double(stringDisplay)!
            
            // perform percent calculation and store as string in string var
            doubleDisplay /= 100
            stringDisplay = String(doubleDisplay)
            if (calculatorState == "left") {
                leftOperand = doubleDisplay
                leftOperandString = stringDisplay
            } else {
                rightOperand = doubleDisplay
                rightOperandString = stringDisplay
                
            }
            
            
            updateDisplay(stringToDisplay: stringDisplay)
        }
        
    }
    
    // calculate result based on operator
    func calculate() {
        
        var result = Double()
        
        // store right operand as Double and reset string
        rightOperand = Double(rightOperandString)
        rightOperandString = ""
        
        // perform calculation based on which operator it is
        switch (calculatorOperator) {
        case "/":
            result = leftOperand! / rightOperand!
            break
        case "X":
            result = leftOperand! * rightOperand!
            break
        case "-":
            result = leftOperand! - rightOperand!
            break
        case "+":
            result = leftOperand! + rightOperand!
            break
        default:
            break
        }
        
        // make previous result left operand and display result
        leftOperandString = String(result)
        updateDisplay(stringToDisplay: leftOperandString)
        setPreviousDisplays(leftOp: leftOperand!, op: calculatorOperator, rightOp: rightOperand!, result: String(result))
        leftOperand = result
        rightOperand = nil
        
        // set calculator state
        calculatorState = "operator"
        
    }
    
    // for displaying previous calculations above current num display
    func setPreviousDisplays(leftOp: Double, op: String, rightOp: Double, result: String) {
        
        // define formatter
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 12
        
        // set the displays
        calculatorPreviousDisplay2.text = "\(formatter.string(from: Double(leftOp) as NSNumber)!) \(op) \(formatter.string(from: Double(rightOp) as NSNumber)!) = "
        calculatorPreviousDisplay1.text = formatter.string(from: Double(result)! as NSNumber)
    }
    
    // update main display
    func updateDisplay(stringToDisplay: String) {
        
        // number formatter
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 12
        
        if (stringToDisplay == "-0") {
            calculatorNumDisplay.text = "0"
        // if it's only a negative and a decimal point, display correctly
        } else if (stringToDisplay == "-.") {
            calculatorNumDisplay.text = "-0."
        }
        // if it's just a decimal, display just a decimal
        else if (stringToDisplay == ".") {
            calculatorNumDisplay.text = "0."
            
        // if it ends in a decimal point
        } else if (stringToDisplay.last == ".") {
            calculatorNumDisplay.text = formatter.string(from: Double(stringToDisplay)! as NSNumber)! + "."
//            if (calculatorState == "left") {
//                leftOperandString = formatter.string(from: Double(stringToDisplay)! as NSNumber)!
//            } else {
//                rightOperandString = formatter.string(from: Double(stringToDisplay)! as NSNumber)!
//            }
            
        // if it starts with a decimal point
        } else if (stringToDisplay.prefix(2) == "0." || stringToDisplay.first == ".") {
            calculatorNumDisplay.text = "0" + formatter.string(from: Double(stringToDisplay)! as NSNumber)!
//            if (calculatorState == "left") {
//                leftOperandString = formatter.string(from: Double(stringToDisplay)! as NSNumber)!
//            } else {
//                rightOperandString = formatter.string(from: Double(stringToDisplay)! as NSNumber)!
//            }
           
        // if it's only a negative sign
        } else if (stringToDisplay == "-") {
            calculatorNumDisplay.text = "-"
            
        // otherwise display the string formatted nicely
        } else {
            calculatorNumDisplay.text = formatter.string(from: Double(stringToDisplay)! as NSNumber)
//            if (calculatorState == "left") {
//                leftOperandString = formatter.string(from: Double(stringToDisplay)! as NSNumber)!
//            } else {
//                rightOperandString = formatter.string(from: Double(stringToDisplay)! as NSNumber)!
//            }
        }
    }
    
}

