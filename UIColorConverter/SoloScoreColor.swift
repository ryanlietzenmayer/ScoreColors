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
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var highTierPercentLabel: UILabel!
    @IBOutlet weak var middleTierPercentLabel: UILabel!
    @IBOutlet weak var lowTierPercentLabel: UILabel!
    @IBOutlet weak var highTierScoreLabel: UILabel!
    @IBOutlet weak var middleTierScoreLabel: UILabel!
    @IBOutlet weak var lowTierScoreLabel: UILabel!
    
    let maxScore = 99.0
    let minScore = 45.0
    let highTierPoint = 0.75
    let middleTierPoint = 0.50
    let lowTierPoint = 0.25
    
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
    
    static let goodScoreColor: UIColor = blueKashmir
    static let highTierPointScoreColor: UIColor = turquoise
    static let middleTierPointScoreColor: UIColor = greenFern
    static let lowTierPointScoreColor: UIColor = yellowLightning
    static let badScoreColor: UIColor = orangeBurnt

    override func viewDidLoad() {
        super .viewDidLoad()
        scoreLabel.keyboardType = .numberPad
        setColor()
        
        highTierPercentLabel.text = String(format:"%.0f", highTierPoint*100) + "%"
        middleTierPercentLabel.text = String(format:"%.0f", middleTierPoint*100) + "%"
        lowTierPercentLabel.text = String(format:"%.0f", lowTierPoint*100) + "%"
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
    }
    @IBAction func textChangedSoloScore(_ sender: Any) {
        if let value: Double = Double(scoreLabel.text!) {
            
            let percentScore = percentFromSoloScore(soloScore: value)
            
            slider.setValue(Float(percentScore), animated: true) //apparently doesn't trigger sliderValueChanged()
            setColor()
        }
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

    func setColor() {
        
        let percentScore = slider.value
        var score = Double(percentScore)
        score = score * (maxScore-minScore)
        score = score+minScore
        
        colorView.backgroundColor = colorFromScore(score)
        slider.minimumTrackTintColor = colorView.backgroundColor
        percentageLabel.text = String(format:"%.2f%", percentScore*100)
    }
    
    func colorFromScore(_ submittedScore: Double) -> UIColor {
        return colorForValueWithinRangeWithMidpoint(value: submittedScore, min: minScore, max: maxScore)
    }
    func colorForValueWithinRangeWithMidpoint(value:Double, min:Double, max:Double) -> UIColor {
        let goodColor = SoloScoreColor.goodScoreColor.cgColor.components!
        let badColor = SoloScoreColor.badScoreColor.cgColor.components!
        let middleHighColor = SoloScoreColor.highTierPointScoreColor.cgColor.components!
        let middleColor = SoloScoreColor.middleTierPointScoreColor.cgColor.components!
        let middleLowColor = SoloScoreColor.lowTierPointScoreColor.cgColor.components!
        
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
            
            var rValue = colorValuePercentage(goodColorComponent: rGood, badColorComponent: rMidH, percentScore: percentScore)
            var gValue = colorValuePercentage(goodColorComponent: gGood, badColorComponent: gMidH, percentScore: percentScore)
            var bValue = colorValuePercentage(goodColorComponent: bGood, badColorComponent: bMidH, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            redLabel.text = String(format:"%.4f", rValue)
            greenLabel.text = String(format:"%.4f", gValue)
            blueLabel.text = String(format:"%.4f", bValue)
            rValue = rValue/255.0
            gValue = gValue/255.0
            bValue = bValue/255.0
            hexLabel.text = String(
                format: "%02X %02X %02X",
                Int(rValue * 0xff),
                Int(gValue * 0xff),
                Int(bValue * 0xff)
            )
            return scoreColor
        } else if value > midM{
            score = score-midM
            let percentScore = score/(midH-midM)
            
            var rValue = colorValuePercentage(goodColorComponent: rMidH, badColorComponent: rMidM, percentScore: percentScore)
            var gValue = colorValuePercentage(goodColorComponent: gMidH, badColorComponent: gMidM, percentScore: percentScore)
            var bValue = colorValuePercentage(goodColorComponent: bMidH, badColorComponent: bMidM, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            redLabel.text = String(format:"%.4f", rValue)
            greenLabel.text = String(format:"%.4f", gValue)
            blueLabel.text = String(format:"%.4f", bValue)
            rValue = rValue/255.0
            gValue = gValue/255.0
            bValue = bValue/255.0
            hexLabel.text = String(
                format: "%02X %02X %02X",
                Int(rValue * 0xff),
                Int(gValue * 0xff),
                Int(bValue * 0xff)
            )
            return scoreColor
            
        } else if value > midL{
            score = score-midL
            let percentScore = score/(midM-midL)
            
            var rValue = colorValuePercentage(goodColorComponent: rMidM, badColorComponent: rMidL, percentScore: percentScore)
            var gValue = colorValuePercentage(goodColorComponent: gMidM, badColorComponent: gMidL, percentScore: percentScore)
            var bValue = colorValuePercentage(goodColorComponent: bMidM, badColorComponent: bMidL, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            redLabel.text = String(format:"%.4f", rValue)
            greenLabel.text = String(format:"%.4f", gValue)
            blueLabel.text = String(format:"%.4f", bValue)
            rValue = rValue/255.0
            gValue = gValue/255.0
            bValue = bValue/255.0
            hexLabel.text = String(
                format: "%02X %02X %02X",
                Int(rValue * 0xff),
                Int(gValue * 0xff),
                Int(bValue * 0xff)
            )
            return scoreColor
        } else {
            score = score-min
            let percentScore = score/(midL-min)
            
            var rValue = colorValuePercentage(goodColorComponent: rMidL, badColorComponent: rBad, percentScore: percentScore)
            var gValue = colorValuePercentage(goodColorComponent: gMidL, badColorComponent: gBad, percentScore: percentScore)
            var bValue = colorValuePercentage(goodColorComponent: bMidL, badColorComponent: bBad, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            redLabel.text = String(format:"%.4f", rValue)
            greenLabel.text = String(format:"%.4f", gValue)
            blueLabel.text = String(format:"%.4f", bValue)
            rValue = rValue/255.0
            gValue = gValue/255.0
            bValue = bValue/255.0
            hexLabel.text = String(
                format: "%02X %02X %02X",
                Int(rValue * 0xff),
                Int(gValue * 0xff),
                Int(bValue * 0xff)
            )
            return scoreColor
        }
    }
    //as of march 22 2018
    func colorForValueWithinRangeWithMidpointOlder(value:Double, min:Double, max:Double) -> UIColor {
        let goodColor = SoloScoreColor.goodScoreColor.cgColor.components!
        let badColor = SoloScoreColor.badScoreColor.cgColor.components!
        let middleColor = SoloScoreColor.middleTierPointScoreColor.cgColor.components!
        
        let rGood = Double(goodColor[0]) * 255.0
        let gGood = Double(goodColor[1]) * 255.0
        let bGood = Double(goodColor[2]) * 255.0
        let rBad = Double(badColor[0]) * 255.0
        let gBad = Double(badColor[1]) * 255.0
        let bBad = Double(badColor[2]) * 255.0
        let rMid = Double(middleColor[0]) * 255.0
        let gMid = Double(middleColor[1]) * 255.0
        let bMid = Double(middleColor[2]) * 255.0
        
        var score = value
        if score>max {
            score = max
        } else if score < min {
            score = min
        }
        
        let mid = ((max-min) * 0.75) + min
        
        if(value>mid){
            score = score-mid
            let percentScore = score/(max-mid)
            
            var rValue = colorValuePercentage(goodColorComponent: rGood, badColorComponent: rMid, percentScore: percentScore)
            var gValue = colorValuePercentage(goodColorComponent: gGood, badColorComponent: gMid, percentScore: percentScore)
            var bValue = colorValuePercentage(goodColorComponent: bGood, badColorComponent: bMid, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            redLabel.text = String(format:"%.4f", rValue)
            greenLabel.text = String(format:"%.4f", gValue)
            blueLabel.text = String(format:"%.4f", bValue)
            rValue = rValue/255.0
            gValue = gValue/255.0
            bValue = bValue/255.0
            hexLabel.text = String(
                format: "%02X %02X %02X",
                Int(rValue * 0xff),
                Int(gValue * 0xff),
                Int(bValue * 0xff)
            )
            return scoreColor
        } else {
            score = score-min
            let percentScore = score/(mid-min)
            
            var rValue = colorValuePercentage(goodColorComponent: rMid, badColorComponent: rBad, percentScore: percentScore)
            var gValue = colorValuePercentage(goodColorComponent: gMid, badColorComponent: gBad, percentScore: percentScore)
            var bValue = colorValuePercentage(goodColorComponent: bMid, badColorComponent: bBad, percentScore: percentScore)
            
            let scoreColor: UIColor = UIColor(red: CGFloat(rValue/255.0),
                                              green: CGFloat(gValue/255.0),
                                              blue: CGFloat(bValue/255.0), alpha: 1.0)
            
            redLabel.text = String(format:"%.4f", rValue)
            greenLabel.text = String(format:"%.4f", gValue)
            blueLabel.text = String(format:"%.4f", bValue)
            rValue = rValue/255.0
            gValue = gValue/255.0
            bValue = bValue/255.0
            hexLabel.text = String(
                format: "%02X %02X %02X",
                Int(rValue * 0xff),
                Int(gValue * 0xff),
                Int(bValue * 0xff)
            )
            return scoreColor
        }
    }
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
    
    func updateTextFromRGB(red:Float, green:Float, blue:Float){
        
    }
    
}
