//
//  WeatherCell.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    lazy var spinner: UIActivityIndicatorView = {
        var indicatorView: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            indicatorView = UIActivityIndicatorView(style: .medium)
        } else {
            indicatorView = UIActivityIndicatorView()
        }
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        return indicatorView
    }()
    
    lazy var customImageView: CustomImageView = {
       let img = CustomImageView()
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var cityLabel: UILabel = {
       let uil = UILabel()
        uil.translatesAutoresizingMaskIntoConstraints = false
        uil.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
        uil.textAlignment = .center
        uil.numberOfLines = 1
        uil.textColor = .white
        return uil
    }()
    
    lazy var tempLabel: UILabel = {
        let uil = UILabel()
         uil.translatesAutoresizingMaskIntoConstraints = false
         uil.font = UIFont.systemFont(ofSize: 25.0, weight: .regular)
         uil.textAlignment = .center
         uil.numberOfLines = 1
         uil.textColor = .white
         return uil
     }()
    
    lazy var containerView: UIView = {
       let uiv = UIView()
        uiv.translatesAutoresizingMaskIntoConstraints = false
        uiv.layer.masksToBounds = true
        uiv.layer.cornerRadius = 7
        
        uiv.addSubview(customImageView)
        uiv.addSubview(cityLabel)
        uiv.addSubview(tempLabel)
        uiv.addSubview(spinner)
        
        [
            customImageView.leadingAnchor.constraint(equalTo: uiv.leadingAnchor, constant: C.horizontalPreviewConstraint),
            customImageView.centerYAnchor.constraint(equalTo: uiv.centerYAnchor),
            customImageView.heightAnchor.constraint(equalToConstant: 55),
            customImageView.widthAnchor.constraint(equalToConstant: 55),
            
            cityLabel.leadingAnchor.constraint(greaterThanOrEqualTo: customImageView.trailingAnchor, constant: C.horizontalPreviewConstraint),
            cityLabel.trailingAnchor.constraint(lessThanOrEqualTo: tempLabel.leadingAnchor, constant: -C.horizontalPreviewConstraint),
            cityLabel.centerYAnchor.constraint(equalTo: uiv.centerYAnchor),
            cityLabel.centerXAnchor.constraint(equalTo: uiv.centerXAnchor),
            
            tempLabel.centerYAnchor.constraint(equalTo: uiv.centerYAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: uiv.trailingAnchor, constant: -C.horizontalPreviewConstraint),
            
            spinner.centerYAnchor.constraint(equalTo: customImageView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: customImageView.centerXAnchor),
        ].forEach { $0.isActive = true }
        
        return uiv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        [
            containerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: C.horizontalMainConstraint),
            containerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -C.horizontalMainConstraint),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: C.verticalPreviewConstraint),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -C.verticalPreviewConstraint),
        ].forEach { $0.isActive = true }
    }
    
    public func configure(_ cityWeather: CityWeather) {
        self.cityLabel.text = cityWeather.name
        self.tempLabel.text = String(Int(cityWeather.main.temp)) + "c"
        DispatchQueue.main.async {
            if let icon = cityWeather.weather.first?.icon {
                self.customImageView.loadImageUsingUrlString(urlString: U.getUrl(for: icon))
            }
        }
        if let weather = cityWeather.weather.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.containerView.removeGradient()
                self.containerView.setGradientBackground(colorTop: weather.main.getLightColor(), colorBottom: weather.main.getDarkColor(), direction: .leftToRight)
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
