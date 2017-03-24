//
//  ViewController.swift
//  SpencerMcFaddenCalculator
//
//  Created by Spencer McFadden-Castro on 1/8/16.
//  Copyright © 2016 Spencer McFadden-Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var operationDisplay: UILabel!
    @IBOutlet weak var functionDisplay: UILabel!
    
    
    var numberTyped: Bool = false
//    var xTyped: Bool = false
//    var yTyped: Bool = false
    var decimalPressed = false
    
    var brain = SpencerMcCalculator()
    
    @IBAction func numberButton(sender: UIButton) {
        let digit = sender.currentTitle!
        if numberTyped {
            operationDisplay.text = operationDisplay.text! + digit
        }
        else {
            operationDisplay.text = digit
            numberTyped = true
        }
    }
    
    @IBAction func piButton(sender: UIButton) {
        let π = M_PI
        if numberTyped {
            operationDisplay.text = operationDisplay.text! + "\(π)"
        }
        else {
            operationDisplay.text = "\(π)"
            numberTyped = true
        }
    }
    
    @IBAction func decimalButton(sender: UIButton) {
        if decimalPressed == false && numberTyped {
            operationDisplay.text = operationDisplay.text! + "."
            decimalPressed = true
        }
        else if decimalPressed == false {
            operationDisplay.text = "."
            decimalPressed = true
            numberTyped = true
        }
    }
    
    @IBAction func operation(sender: UIButton) {
        if numberTyped {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
            else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        numberTyped = false
        decimalPressed = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            displayValue = 0
        }
    }
	
    @IBAction func clear(sender: AnyObject) {
        numberTyped = false
        brain.clear()
        operationDisplay.text = "0"
        enter()
    }
    
//    @IBAction func deleteOne(sender: AnyObject) {
//        numberTyped = false
//        brain.deleteOne()
//        operationDisplay.text = "0"
//        enter()
//    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(operationDisplay.text!)!.doubleValue
        }
        set{
            operationDisplay.text = "=\(newValue)"
            numberTyped = false
        }
    }
    
}

