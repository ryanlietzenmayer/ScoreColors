//
//  ViewController.swift
//  UIColorConverter
//
//  Created by Ryan Lietzenmayer on 8/28/17.
//  Copyright © 2017 Ryan Lietzenmayer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var hexViewInput: UITextField!
    @IBOutlet weak var alphaView: UITextField!
    
    @IBOutlet weak var RGBInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RGBValueChanged(_ sender: Any) {
        
    }
    
    @IBAction func hexValueChanged(_ sender: Any) {
        
        //Get hex value
        if let str = hexViewInput?.text {
            if (str.characters.count == 6 ){
                
                //TODO: can't handle non-hex input, sanitize
                //Get R
                let rIndex = str.index(str.startIndex, offsetBy: 2)
                let rStr = str.substring(to: rIndex)
                let valueR = CGFloat(UInt8(rStr, radix: 16)!)

                //Get G
                let start = str.index(str.startIndex, offsetBy: 2)
                let end = str.index(str.endIndex, offsetBy: -2)
                let range = start..<end
                let gStr = str.substring(with: range)  // play
                let valueG = CGFloat(UInt8(gStr, radix: 16)!)
                
                //Get B
                let index = str.index(str.startIndex, offsetBy: 4)
                let bStr = str.substring(from: index)  // playground
                let valueB = CGFloat(UInt8(bStr, radix: 16)!)

                //TODO: Get Alpha
                
                colorView.backgroundColor = UIColor(red: valueR/255.0, green: valueG/255.0, blue: valueB/255.0, alpha: 1.0)
                
                //print values to text view
                let combostring = "R " + "\(valueR)" + ", G " + "\(valueG)" + ", B " + "\(valueB)"
                RGBInput.text = combostring
            }
        }
    }
}

