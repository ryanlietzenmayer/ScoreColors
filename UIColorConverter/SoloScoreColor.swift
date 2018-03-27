//
//  SoloScoreColor.swift
//  UIColorConverter
//
//  Created by Ryan Lietzenmayer on 3/21/18.
//  Copyright © 2018 Ryan Lietzenmayer. All rights reserved.
//

import Foundation
import UIKit

class SoloScoreColor: UIViewController {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var scoreLabel: UITextField!
    @IBOutlet weak var scoreLabelPretty: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var highTierPercentTextField: UITextField!
    @IBOutlet weak var middleTierPercentTextField: UITextField!
    @IBOutlet weak var lowTierPercentTextField: UITextField!
    
    @IBOutlet weak var rMaxTierTextField: UITextField!
    @IBOutlet weak var gMaxTierTextField: UITextField!
    @IBOutlet weak var bMaxTierTextField: UITextField!

    @IBOutlet weak var rHighTierTextField: UITextField!
    @IBOutlet weak var gHighTierTextField: UITextField!
    @IBOutlet weak var bHighTierTextField: UITextField!
    
    @IBOutlet weak var rMidTierTextField: UITextField!
    @IBOutlet weak var gMidTierTextField: UITextField!
    @IBOutlet weak var bMidTierTextField: UITextField!
    
    @IBOutlet weak var rLowTierTextField: UITextField!
    @IBOutlet weak var gLowTierTextField: UITextField!
    @IBOutlet weak var bLowTierTextField: UITextField!
    
    @IBOutlet weak var rMinTierTextField: UITextField!
    @IBOutlet weak var gMinTierTextField: UITextField!
    @IBOutlet weak var bMinTierTextField: UITextField!

    @IBOutlet weak var highTierScoreLabel: UILabel!
    @IBOutlet weak var middleTierScoreLabel: UILabel!
    @IBOutlet weak var lowTierScoreLabel: UILabel!
    
    @IBOutlet weak var maxPointLabel: UILabel!
    @IBOutlet weak var highPointLabel: UILabel!
    @IBOutlet weak var midPointLabel: UILabel!
    @IBOutlet weak var lowPointLabel: UILabel!
    @IBOutlet weak var minPointLabel: UILabel!
    
    @IBOutlet weak var demoView0: UIView!
    @IBOutlet weak var demoView10: UIView!
    @IBOutlet weak var demoView20: UIView!
    @IBOutlet weak var demoView30: UIView!
    @IBOutlet weak var demoView40: UIView!
    @IBOutlet weak var demoView50: UIView!
    @IBOutlet weak var demoView60: UIView!
    @IBOutlet weak var demoView70: UIView!
    @IBOutlet weak var demoView80: UIView!
    @IBOutlet weak var demoView90: UIView!
    @IBOutlet weak var demoView100: UIView!
    
    //  Lightning Yellow; #FCBE24, rgb(252,190,36)
    private static let yellowLightning: UIColor = UIColor(rgb:0xFCBE24)
    //  Kashmir Blue; #4F6D8D, rgb(79,109,141)
    private static let blueKashmir: UIColor = UIColor(rgb:0x4F6D8D)
    //  Turquoise; #51C6C9, rgb(81,198,201)
    private static let turquoise: UIColor = UIColor(rgb:0x51C6C9)
    // Fern Green; #58B060, rgb(88,176,96)
    private static let greenFern: UIColor = UIColor(rgb:0x58B060)
    //  Burnt Orange; #F5873A, rgb(245,135,58)
    private static let orangeBurnt: UIColor = UIColor(rgb:0xF5873A)
    
    //new colors
    private static let turquoise1: UIColor = UIColor(rgb:0x1DCEFF)
    private static let green1: UIColor = UIColor(rgb:0x4AC427)
    private static let yellow1: UIColor = UIColor(rgb:0xF2B319)
    private static let orange1: UIColor = UIColor(rgb:0xEA772A)
    private static let red1: UIColor = UIColor(rgb:0xE24A0E)

    
//    static let goodColor: UIColor = turquoise
//    static let midColor: UIColor = greenFern
//    static let badColor: UIColor = yellowLightning
    
    
    var maxTierPointScoreColor: UIColor = turquoise1
    var highTierPointScoreColor: UIColor = green1
    var middleTierPointScoreColor: UIColor = yellow1
    var lowTierPointScoreColor: UIColor = orange1
    var minTierPointScoreColor: UIColor = red1
    
    let maxScore = 99.0
    let minScore = 0.0
    
    var highTierPoint = 0.80
    var middleTierPoint = 0.60
    var lowTierPoint = 0.40

    
    override func viewDidLoad() {
        super .viewDidLoad()
        setColor()
        
        scoreLabel.keyboardType = .numberPad
        let score = soloScoreFromPercent(Double(slider.value))
        scoreLabel.text = String(format:"%.2f", score)
        scoreLabelPretty.text = String(format:"%.0f", score)
        
        highTierPercentTextField.text = String(format:"%.0f", highTierPoint*100)
        middleTierPercentTextField.text = String(format:"%.0f", middleTierPoint*100)
        lowTierPercentTextField.text = String(format:"%.0f", lowTierPoint*100)
        
        highTierScoreLabel.text = String(format:"%.2f", soloScoreFromPercent(highTierPoint))
        middleTierScoreLabel.text = String(format:"%.2f", soloScoreFromPercent(middleTierPoint))
        lowTierScoreLabel.text = String(format:"%.2f", soloScoreFromPercent(lowTierPoint))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        setColor()
        let score = soloScoreFromPercent(Double(slider.value))
        scoreLabel.text = String(format:"%.2f", score)
        scoreLabelPretty.text = String(format:"%.0f", score)
    }
    
    @IBAction func textChangedSoloScore(_ sender: Any) {
        if let value: Double = Double(scoreLabel.text!) {
            
            scoreLabelPretty.text = String(format:"%.0f", value)

            let percentScore = percentFromSoloScore(soloScore: value)
            slider.setValue(Float(percentScore), animated: true) //apparently doesn't trigger sliderValueChanged()
            setColor()
        }
    }
    
    
    @IBAction func maxHexEditingChanged(_ sender: Any) {
        if let rStr = rMaxTierTextField.text,
            let gStr = gMaxTierTextField.text,
            let bStr = bMaxTierTextField.text {
            
            if var rHexNum = Int(rStr, radix:16),
                var gHexNum = Int(gStr, radix:16),
                var bHexNum = Int(bStr, radix:16) {
                
                if rHexNum>255{
                    rHexNum = 255
                }
                if gHexNum>255{
                    gHexNum = 255
                }
                if bHexNum>255{
                    bHexNum = 255
                }

                let color: UIColor = UIColor(red:rHexNum, green:gHexNum, blue:bHexNum)
                maxTierPointScoreColor = color
            }
        }
        setColor()
    }

    @IBAction func highHexEditingChanged(_ sender: Any) {
        if let rStr = rHighTierTextField.text,
            let gStr = gHighTierTextField.text,
            let bStr = bHighTierTextField.text {
            
            if var rHexNum = Int(rStr, radix:16),
                var gHexNum = Int(gStr, radix:16),
                var bHexNum = Int(bStr, radix:16) {
                
                if rHexNum>255{
                    rHexNum = 255
                }
                if gHexNum>255{
                    gHexNum = 255
                }
                if bHexNum>255{
                    bHexNum = 255
                }

                let color: UIColor = UIColor(red:rHexNum, green:gHexNum, blue:bHexNum)
                highTierPointScoreColor = color
            }
        }
        setColor()
    }
    @IBAction func midHexEditingChanged(_ sender: Any) {
        if let rStr = rMidTierTextField.text,
            let gStr = gMidTierTextField.text,
            let bStr = bMidTierTextField.text {
            
            if var rHexNum = Int(rStr, radix:16),
                var gHexNum = Int(gStr, radix:16),
                var bHexNum = Int(bStr, radix:16) {
                
                if rHexNum>255{
                    rHexNum = 255
                }
                if gHexNum>255{
                    gHexNum = 255
                }
                if bHexNum>255{
                    bHexNum = 255
                }

                let color: UIColor = UIColor(red:rHexNum, green:gHexNum, blue:bHexNum)
                middleTierPointScoreColor = color
            }
        }
        setColor()
    }
    @IBAction func lowHexEditingChanged(_ sender: Any) {
        if let rStr = rLowTierTextField.text,
            let gStr = gLowTierTextField.text,
            let bStr = bLowTierTextField.text {
            
            if var rHexNum = Int(rStr, radix:16),
                var gHexNum = Int(gStr, radix:16),
                var bHexNum = Int(bStr, radix:16) {
                
                if rHexNum>255{
                    rHexNum = 255
                }
                if gHexNum>255{
                    gHexNum = 255
                }
                if bHexNum>255{
                    bHexNum = 255
                }

                let color: UIColor = UIColor(red:rHexNum, green:gHexNum, blue:bHexNum)
                lowTierPointScoreColor = color
            }
        }
        setColor()
    }
    @IBAction func minHexEditingChanged(_ sender: Any) {
        if let rStr = rMinTierTextField.text,
            let gStr = gMinTierTextField.text,
            let bStr = bMinTierTextField.text {
            
            if var rHexNum = Int(rStr, radix:16),
                var gHexNum = Int(gStr, radix:16),
                var bHexNum = Int(bStr, radix:16) {
                
                if rHexNum>255{
                    rHexNum = 255
                }
                if gHexNum>255{
                    gHexNum = 255
                }
                if bHexNum>255{
                    bHexNum = 255
                }

                let color: UIColor = UIColor(red:rHexNum, green:gHexNum, blue:bHexNum)
                minTierPointScoreColor = color
            }
        }
        setColor()
    }
    
    
    @IBAction func highPercentEditingChanged(_ sender: Any) {
        if var value: Double = Double(highTierPercentTextField.text!) {
            while value>1 {
                value = value/100
            }
            highTierPoint = value
            
            let score = soloScoreFromPercent(highTierPoint)
            highTierScoreLabel.text = String(format:"%.2f", score)
        }
        setColor()
    }
    @IBAction func midPercentEditingChanged(_ sender: Any) {
        if var value: Double = Double(middleTierPercentTextField.text!) {
            while value>1 {
                value = value/100
            }
            middleTierPoint = value
            
            let score = soloScoreFromPercent(middleTierPoint)
            middleTierScoreLabel.text = String(format:"%.2f", score)
        }
        setColor()
    }
    @IBAction func lowPercentEditingChanged(_ sender: Any) {
        if var value: Double = Double(lowTierPercentTextField.text!) {
            while value>1 {
                value = value/100
            }
            lowTierPoint = value
            
            let score = soloScoreFromPercent(lowTierPoint)
            lowTierScoreLabel.text = String(format:"%.2f", score)
        }
        setColor()
    }
    
    func soloScoreFromPercent(_ percent:Double) -> Double{
        var percentFormatted = percent
        while percentFormatted>1 {
            percentFormatted = percentFormatted/100
        }
        
        var score = percentFormatted
        score = score * (maxScore-minScore)
        score = score+minScore
        
        return score
    }
    func percentFromSoloScore(soloScore:Double) -> Double{
        var score = soloScore
        if score>maxScore {
            score = maxScore
        } else if score < minScore {
            score = minScore
        }
        score = score-minScore
        let percentScore = score/(maxScore-minScore)
        
        return percentScore
    }
    
    func setBackgroundDemoColors() {
        demoView0.backgroundColor = colorFromScore(soloScoreFromPercent(0.0))
        demoView10.backgroundColor = colorFromScore(soloScoreFromPercent(10.0))
        demoView20.backgroundColor = colorFromScore(soloScoreFromPercent(20.0))
        demoView30.backgroundColor = colorFromScore(soloScoreFromPercent(30.0))
        demoView40.backgroundColor = colorFromScore(soloScoreFromPercent(40.0))
        demoView50.backgroundColor = colorFromScore(soloScoreFromPercent(50.0))
        demoView60.backgroundColor = colorFromScore(soloScoreFromPercent(60.0))
        demoView70.backgroundColor = colorFromScore(soloScoreFromPercent(70.0))
        demoView80.backgroundColor = colorFromScore(soloScoreFromPercent(80.0))
        demoView90.backgroundColor = colorFromScore(soloScoreFromPercent(90.0))
        demoView100.backgroundColor = colorFromScore(soloScoreFromPercent(100.0))
    }
    
    func setColor() {
        let maxColorVals = SoloScoreColor.hexStringFromUIColor(color: maxTierPointScoreColor)
        rMaxTierTextField.text = maxColorVals[0]
        gMaxTierTextField.text = maxColorVals[1]
        bMaxTierTextField.text = maxColorVals[2]
        let highColorVals = SoloScoreColor.hexStringFromUIColor(color: highTierPointScoreColor)
        rHighTierTextField.text = highColorVals[0]
        gHighTierTextField.text = highColorVals[1]
        bHighTierTextField.text = highColorVals[2]
        let midColorVals = SoloScoreColor.hexStringFromUIColor(color: middleTierPointScoreColor)
        rMidTierTextField.text = midColorVals[0]
        gMidTierTextField.text = midColorVals[1]
        bMidTierTextField.text = midColorVals[2]
        let lowColorVals = SoloScoreColor.hexStringFromUIColor(color: lowTierPointScoreColor)
        rLowTierTextField.text = lowColorVals[0]
        gLowTierTextField.text = lowColorVals[1]
        bLowTierTextField.text = lowColorVals[2]
        let minColorVals = SoloScoreColor.hexStringFromUIColor(color: minTierPointScoreColor)
        rMinTierTextField.text = minColorVals[0]
        gMinTierTextField.text = minColorVals[1]
        bMinTierTextField.text = minColorVals[2]

        maxPointLabel.backgroundColor = maxTierPointScoreColor
        highPointLabel.backgroundColor = highTierPointScoreColor
        midPointLabel.backgroundColor = middleTierPointScoreColor
        lowPointLabel.backgroundColor = lowTierPointScoreColor
        minPointLabel.backgroundColor = minTierPointScoreColor
        
        setBackgroundDemoColors()
        
        let percentScore = slider.value
        var score = Double(percentScore)
        score = score * (maxScore-minScore)
        score = score+minScore
        
        colorView.backgroundColor = colorFromScore(score)
        slider.minimumTrackTintColor = colorView.backgroundColor
        percentageLabel.text = String(format:"%.2f", percentScore*100) + "%"
    }
    
    func colorFromScore(_ submittedScore: Double) -> UIColor {
        //return colorForValueWithinRangeWithMidpointOlder(value: submittedScore, min: minScore, max: maxScore)
        return colorForValueWithinRangeWithMidpoint(value: submittedScore, min: minScore, max: maxScore)
    }
    
    func colorForValueWithinRangeWithMidpoint(value:Double, min:Double, max:Double) -> UIColor {
        let goodColor = maxTierPointScoreColor.cgColor.components!
        let badColor = minTierPointScoreColor.cgColor.components!
        let middleHighColor = highTierPointScoreColor.cgColor.components!
        let middleColor = middleTierPointScoreColor.cgColor.components!
        let middleLowColor = lowTierPointScoreColor.cgColor.components!
        
        let rGood = Double(goodColor[0]) * 255.0
        let gGood = Double(goodColor[1]) * 255.0
        let bGood = Double(goodColor[2]) * 255.0
        let rBad = Double(badColor[0]) * 255.0
        let gBad = Double(badColor[1]) * 255.0
        let bBad = Double(badColor[2]) * 255.0
        let rMidH = Double(middleHighColor[0]) * 255.0
        let gMidH = Double(middleHighColor[1]) * 255.0
        let bMidH = Double(middleHighColor[2]) * 255.0
        let rMidM = Double(middleColor[0]) * 255.0
        let gMidM = Double(middleColor[1]) * 255.0
        let bMidM = Double(middleColor[2]) * 255.0
        let rMidL = Double(middleLowColor[0]) * 255.0
        let gMidL = Double(middleLowColor[1]) * 255.0
        let bMidL = Double(middleLowColor[2]) * 255.0
        
        var score = value
        if score>max {
            score = max
        } else if score < min {
            score = min
        }
        
        let midH = ((max-min) * highTierPoint) + min
        let midM = ((max-min) * middleTierPoint) + min
        let midL = ((max-min) * lowTierPoint) + min
        
        if value>midH {
            score = score-midH
            let percentScore = score/(max-midH)
            
            let rValue = colorValuePercentage(goodColorComponent: rGood, badColorComponent: rMidH, percentScore: percentScore)
            let gValue = colorValuePercentage(goodColorComponent: gGood, badColorComponent: gMidH, percentScore: percentScore)
            let bValue = colorValuePercentage(goodColorComponent: bGood, badColorComponent: bMidH, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            updateTextFromRGB(red: rValue, green: gValue, blue: bValue)
            return scoreColor
        } else if value > midM{
            score = score-midM
            let percentScore = score/(midH-midM)
            
            let rValue = colorValuePercentage(goodColorComponent: rMidH, badColorComponent: rMidM, percentScore: percentScore)
            let gValue = colorValuePercentage(goodColorComponent: gMidH, badColorComponent: gMidM, percentScore: percentScore)
            let bValue = colorValuePercentage(goodColorComponent: bMidH, badColorComponent: bMidM, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            updateTextFromRGB(red: rValue, green: gValue, blue: bValue)
            return scoreColor
            
        } else if value > midL{
            score = score-midL
            let percentScore = score/(midM-midL)
            
            let rValue = colorValuePercentage(goodColorComponent: rMidM, badColorComponent: rMidL, percentScore: percentScore)
            let gValue = colorValuePercentage(goodColorComponent: gMidM, badColorComponent: gMidL, percentScore: percentScore)
            let bValue = colorValuePercentage(goodColorComponent: bMidM, badColorComponent: bMidL, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            updateTextFromRGB(red: rValue, green: gValue, blue: bValue)
            return scoreColor
        } else {
            score = score-min
            let percentScore = score/(midL-min)
            
            let rValue = colorValuePercentage(goodColorComponent: rMidL, badColorComponent: rBad, percentScore: percentScore)
            let gValue = colorValuePercentage(goodColorComponent: gMidL, badColorComponent: gBad, percentScore: percentScore)
            let bValue = colorValuePercentage(goodColorComponent: bMidL, badColorComponent: bBad, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            updateTextFromRGB(red: rValue, green: gValue, blue: bValue)
            return scoreColor
        }
    }
    //as of march 22 2018
//    func colorForValueWithinRangeWithMidpointOlder(value:Double, min:Double, max:Double) -> UIColor {
//        let goodColor = SoloScoreColor.goodColor.cgColor.components!
//        let badColor = SoloScoreColor.badColor.cgColor.components!
//        let middleColor = SoloScoreColor.midColor.cgColor.components!
//
//        let rGood = Double(goodColor[0]) * 255.0
//        let gGood = Double(goodColor[1]) * 255.0
//        let bGood = Double(goodColor[2]) * 255.0
//        let rBad = Double(badColor[0]) * 255.0
//        let gBad = Double(badColor[1]) * 255.0
//        let bBad = Double(badColor[2]) * 255.0
//        let rMid = Double(middleColor[0]) * 255.0
//        let gMid = Double(middleColor[1]) * 255.0
//        let bMid = Double(middleColor[2]) * 255.0
//
//        var score = value
//        if score>max {
//            score = max
//        } else if score < min {
//            score = min
//        }
//
//        let mid = ((max-min) * 0.75) + min
//
//        if(value>mid){
//            score = score-mid
//            let percentScore = score/(max-mid)
//
//            let rValue = colorValuePercentage(goodColorComponent: rGood, badColorComponent: rMid, percentScore: percentScore)
//            let gValue = colorValuePercentage(goodColorComponent: gGood, badColorComponent: gMid, percentScore: percentScore)
//            let bValue = colorValuePercentage(goodColorComponent: bGood, badColorComponent: bMid, percentScore: percentScore)
//
//            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
//                                              green: CGFloat(gValue/255.0),
//                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
//
//            updateTextFromRGB(red: rValue, green: gValue, blue: bValue)
//            return scoreColor
//        } else {
//            score = score-min
//            let percentScore = score/(mid-min)
//
//            let rValue = colorValuePercentage(goodColorComponent: rMid, badColorComponent: rBad, percentScore: percentScore)
//            let gValue = colorValuePercentage(goodColorComponent: gMid, badColorComponent: gBad, percentScore: percentScore)
//            let bValue = colorValuePercentage(goodColorComponent: bMid, badColorComponent: bBad, percentScore: percentScore)
//
//            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
//                                              green: CGFloat(gValue/255.0),
//                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
//
//            updateTextFromRGB(red: rValue, green: gValue, blue: bValue)
//            return scoreColor
//        }
//    }
    func colorValuePercentage(goodColorComponent: Double, badColorComponent: Double, percentScore: Double) -> Double{
        if goodColorComponent < badColorComponent {
            let inversePercentScore = (percentScore-1) * -1
            let percent = badColorComponent - goodColorComponent
            var value = percent * inversePercentScore
            value = value + goodColorComponent
            return value
        } else {
            let percent = goodColorComponent - badColorComponent
            var value = percent * percentScore
            value = value + badColorComponent
            return value
        }
    }
    
    func updateTextFromRGB(red:Double, green:Double, blue:Double){
        var rValue = red
        var gValue = green
        var bValue = blue
        
        redLabel.text = String(format:"%.0f", rValue)
        greenLabel.text = String(format:"%.0f", gValue)
        blueLabel.text = String(format:"%.0f", bValue)
        rValue = rValue/255.0
        gValue = gValue/255.0
        bValue = bValue/255.0
        hexLabel.text = String(
            format: "%02X %02X %02X",
            Int(rValue * 0xff),
            Int(gValue * 0xff),
            Int(bValue * 0xff)
        )
    }
    
    static func hexStringFromUIColor(color:UIColor) -> [String] {
        let components = color.cgColor.components
        let r = components![0]
        let g = components![1]
        let b = components![2]
        let hexString = [String(format:"%02X",Int(r * 0xff)),
                         String(format:"%02X",Int(g * 0xff)),
                         String(format:"%02X",Int(b * 0xff))]
        return hexString
    }
    
}
