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
    
    
    //  Lightning Yellow; #FCBE24, rgb(252,190,36)
    private static let yellowLightning: UIColor = UIColor(rgb:0xFCBE24)
    //  Turquoise; #51C6C9, rgb(81,198,201)
    private static let turquoise: UIColor = UIColor(rgb:0x51C6C9)
    // Fern Green; #58B060, rgb(88,176,96)
    private static let greenFern: UIColor = UIColor(rgb:0x58B060)

    static let goodScoreColor: UIColor = turquoise
    static let badScoreColor: UIColor = yellowLightning
    static let middleScoreColor: UIColor = greenFern
    static let badScoreColorWhenWithMiddle: UIColor = yellowLightning

    override func viewDidLoad() {
        super .viewDidLoad()
        scoreLabel.keyboardType = .numberPad
        setColor()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        setColor()
        
        let max = 99.0
        let min = 45.0
        let percentScore = slider.value
        var score = Double(percentScore)
        score = score * (max-min)
        score = score+min
        scoreLabel.text = String(format:"%.2f", score)
    }
    @IBAction func textChangedSoloScore(_ sender: Any) {
        if let value: Double = Double(scoreLabel.text!) {
            let max = 99.0
            let min = 45.0

            var score = value
            if score>max {
                score = max
            } else if score < min {
                score = min
            }
            score = score-min
            let percentScore = score/(max-min)

            slider.setValue(Float(percentScore), animated: true) //apparently doesn't trigger sliderValueChanged()
            setColor()
        }
    }
    
    func setColor() {
        let max = 99.0
        let min = 45.0

        let percentScore = slider.value
        var score = Double(percentScore)
        score = score * (max-min)
        score = score+min
        
        colorView.backgroundColor = colorFromScore(score)
        slider.minimumTrackTintColor = colorView.backgroundColor
        percentageLabel.text = String(format:"%.2f%", percentScore*100)
    }
    
    func colorFromScore(_ submittedScore: Double) -> UIColor {
        //format score
        let maxScore = 99.0
        let minScore = 45.0
        
        return colorForValueWithinRangeWithMidpoint(value: submittedScore, min: minScore, max: maxScore)
    }
    func colorForValueWithinRangeWithMidpoint(value:Double, min:Double, max:Double) -> UIColor {
        let goodColor = SoloScoreColor.goodScoreColor.cgColor.components!
        let badColor = SoloScoreColor.badScoreColorWhenWithMiddle.cgColor.components!
        let middleColor = SoloScoreColor.middleScoreColor.cgColor.components!
        
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

}
