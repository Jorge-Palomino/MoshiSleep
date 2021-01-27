//
//  Extensions.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation
import UIKit

extension UIColor {
    static var darkBackground: UIColor {
        return UIColor(named: "background-dark") ?? UIColor.init(red: 1, green: 0, blue: 2, alpha: 1)
    }
    
    static var lightBackground: UIColor {
        return UIColor(named: "background-light") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var darkSunny: UIColor {
        return UIColor(named: "sunny-dark") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var lightSunny: UIColor {
        return UIColor(named: "sunny-light") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var darkRain: UIColor {
        return UIColor(named: "rain-dark") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var lightRain: UIColor {
        return UIColor(named: "rain-light") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var darkThunder: UIColor {
        return UIColor(named: "thunder-dark") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var lightThunder: UIColor {
        return UIColor(named: "thunder-light") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var darkSnow: UIColor {
        return UIColor(named: "snow-dark") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var lightSnow: UIColor {
        return UIColor(named: "snow-light") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var darkCloud: UIColor {
        return UIColor(named: "cloud-dark") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var lightCloud: UIColor {
        return UIColor(named: "cloud-light") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
    static var active: UIColor {
        return UIColor(named: "active") ?? UIColor.init(red: 43, green: 40, blue: 46, alpha: 1)
    }
}

enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

extension UIView {
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor, direction: GradientDirection ) {
        let colorTop =  colorTop.cgColor
        let colorBottom = colorBottom.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.cornerRadius = 7
        switch direction {
            case .leftToRight:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .rightToLeft:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            case .bottomToTop:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            default:
                break
        }
        gradientLayer.name = "GradientBackground"
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func removeGradient() {
        let backgroundLayers = layer.sublayers?.filter({$0.name == "GradientBackground"})
        backgroundLayers?.forEach { lay in
            lay.removeFromSuperlayer()
        }
    }
}
