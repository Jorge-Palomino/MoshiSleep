//
//  WeatherDetailCell.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import UIKit

class WeatherDetailCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var weatherIcon: CustomImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var feelTempView: UIView!
    @IBOutlet weak var feelLabel: UILabel!
    @IBOutlet weak var feelWidthConstraint: NSLayoutConstraint!    
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var humIcon: UIImageView!
    @IBOutlet weak var pressIcon: UIImageView!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var pressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 7
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = UIColor.white.cgColor
        
        feelTempView.backgroundColor = .active
        feelTempView.layer.masksToBounds = true
        feelTempView.layer.cornerRadius = feelTempView.frame.height / 2
        
        pressIcon.image = pressIcon.image?.withRenderingMode(.alwaysTemplate)
        humIcon.image = humIcon.image?.withRenderingMode(.alwaysTemplate)
        pressIcon.tintColor = .white
        humIcon.tintColor = .white
    }
    
    func configure(with cityWeather: CityWeather) {
        self.cityLabel.text = cityWeather.name
        self.tempLabel.text = String(Int(cityWeather.main.temp)) + "c"
        self.weatherLabel.text = cityWeather.weather.first?.main.rawValue
        humLabel.text = String(cityWeather.main.humidity) + "%"
        pressLabel.text = String(cityWeather.main.pressure) + " hPa"
        
        highTempLabel.text = "H " + String(Int(cityWeather.main.tempMax)) + "c"
        lowTempLabel.text = "L " + String(Int(cityWeather.main.tempMin)) + "c"
        
        if let text = highTempLabel.text {
            let attriString = NSMutableAttributedString(string: text)
            let userRange = (text as NSString).range(of: "H")
            attriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15, weight: .medium), range: userRange)
            highTempLabel.attributedText = attriString
        }
        
        if let text = lowTempLabel.text {
            let attriString = NSMutableAttributedString(string: text)
            let userRange = (text as NSString).range(of: "L")
            attriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15, weight: .medium), range: userRange)
            lowTempLabel.attributedText = attriString
        }
        
        
        let text = "Feels like " + String(Int(cityWeather.main.feelsLike)) + "c"
        feelWidthConstraint.constant = U.estimateFrameForText(text: text, font: feelLabel.font!, size: CGSize(width: self.frame.width - 30, height: .infinity)).width + 25.0
        feelLabel.text = text
        
        DispatchQueue.main.async {
            if let icon = cityWeather.weather.first?.icon {
                self.weatherIcon.loadImageUsingUrlString(urlString: U.getUrl(for: icon))
            }
        }
    }

}
