//
//  Utilities.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation
import UIKit

class U {
    
    static func saveCurrentCities (cities: [CityWeather]?) {
        if let cities = cities {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(cities) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: C.defaultsKeys.cityWeathers)
                defaults.synchronize()
            }
        }else {
            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: C.defaultsKeys.cityWeathers)
            defaults.synchronize()
        }
    }
    
    static func getCurrentWeathers () -> [CityWeather]? {
        let defaults = UserDefaults.standard
        if let saved = defaults.object(forKey: C.defaultsKeys.cityWeathers) as? Data {
            let decoder = JSONDecoder()
            if let information = try? decoder.decode([CityWeather].self, from: saved) {
                return information
            }
        }
        return nil
    }
    
    static func getUrl(for icon: String) -> String {
        return C.Constants.imageUrl + icon + C.Constants.x2 + C.Constants.png
    }
    
    static func estimateFrameForText(text: String, font: UIFont?, size: CGSize? = nil) -> CGRect {
        let window = UIApplication.shared.keyWindow
        let leftPadding = window?.safeAreaInsets.left ?? 0
        let rightPadding = window?.safeAreaInsets.right ?? 0
        let contentSize = size == nil ? CGSize(width: window?.bounds.width ?? UIScreen.main.bounds.width - leftPadding - rightPadding - 40, height: 0) : size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = font ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        return NSString(string: text).boundingRect(with: contentSize!, options: options, attributes: [NSAttributedString.Key.font: attributes], context: nil)
    }
    
    static func imageView(imageName: String, selector: Selector, target: Any, frame: CGRect = CGRect(x: 0, y: 0, width: 35, height: 35)) -> UIImageView {
        let logo = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        let logoImageView = UIImageView(frame: frame)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = logo
        logoImageView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        logoImageView.tintColor = .white
        logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
        return logoImageView
    }

    static func barImageView(imageName: String, selector: Selector, target: Any, frame: CGRect = CGRect(x: 0, y: 0, width: 35, height: 35)) -> UIBarButtonItem {
        return UIBarButtonItem(customView: U.imageView(imageName: imageName, selector: selector, target: target, frame: frame))
    }
    
    enum alertType {
        case error
        case done
    }
    
    static func showAlertMessage (superview: UIView, alertType: alertType, alerText: String, timeout: Double) {
        DispatchQueue.main.async(execute: {
            let popOver = UIView()
            popOver.backgroundColor = .black
            popOver.center = superview.center
            popOver.layer.cornerRadius = 9
            popOver.layer.zPosition = 5000
            popOver.alpha = 0.8
            superview.addSubview(popOver)
            popOver.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            
            let icon = UIImageView()
            if alertType == .error {
                icon.image = UIImage(named: "icon-error")
            }else if alertType == .done {
                icon.image = UIImage(named: "icon-checkmark")
            }
            icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = .white
            popOver.addSubview(icon)
            popOver.bringSubviewToFront(icon)
            icon.translatesAutoresizingMaskIntoConstraints = false
            
            let lbl = UILabel()
            lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
            lbl.text = alerText
            lbl.textColor = .white
            lbl.numberOfLines = 0
            lbl.adjustsFontSizeToFitWidth = true
            lbl.textAlignment = .center
            popOver.addSubview(lbl)
            popOver.bringSubviewToFront(lbl)
            popOver.translatesAutoresizingMaskIntoConstraints = false
            lbl.translatesAutoresizingMaskIntoConstraints = false
            
            let widthView = popOver.widthAnchor.constraint(equalToConstant: 170)
            let bottomView = popOver.bottomAnchor.constraint(equalTo: lbl.bottomAnchor, constant: 10)
            let centerXView = popOver.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
            let centerYView = popOver.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            
            let widthIcon = icon.widthAnchor.constraint(equalToConstant: 60)
            let heightIcon = icon.heightAnchor.constraint(equalToConstant: 60)
            let centerXIcon = icon.centerXAnchor.constraint(equalTo: popOver.centerXAnchor)
            let topIcon = icon.topAnchor.constraint(equalTo: popOver.topAnchor, constant: 15)
            
            let widthLbl = lbl.widthAnchor.constraint(equalToConstant: 150)
            let centerXLbl = lbl.centerXAnchor.constraint(equalTo: popOver.centerXAnchor)
            let bottomLbl = lbl.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20)
            
            NSLayoutConstraint.activate([
                widthView, bottomView, centerXView, centerYView,
                widthIcon, heightIcon, centerXIcon, topIcon,
                widthLbl, centerXLbl, bottomLbl
            ])

            UIView.animate(withDuration: 0.2, animations: {
                popOver.alpha = 0.8
                popOver.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                UIView.animate(withDuration: 0.7, animations: {
                    popOver.alpha = 0
                    popOver.transform = CGAffineTransform.init(translationX: 0, y: 50)
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeout + 1.0) {
                        popOver.removeFromSuperview()
                    }
                })
            }
        })
    }
    static var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.02, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

}
