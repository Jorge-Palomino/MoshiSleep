//
//  MapCell.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation
import UIKit
import MapKit

class MapCell: UITableViewCell {
    
    lazy var mapView: MKMapView = {
        let mp = MKMapView()
        mp.translatesAutoresizingMaskIntoConstraints = false
        mp.mapType = .standard
        mp.layer.masksToBounds = true
        mp.layer.cornerRadius = 7
        return mp
    }()
    
    var cityWeather: CityWeather?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        backgroundColor = .clear
        
        contentView.addSubview(mapView)
        
        [
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mapView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mapView.widthAnchor.constraint(equalToConstant: 240),
        ].forEach { $0.isActive = true }
        
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    public func configure(with weather: CityWeather) {
        mapView.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude: weather.coordinates.lat, longitude: weather.coordinates.lon)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = weather.name + " • " + String(Int(weather.main.temp)) + "c"
        
        mapView.addAnnotation(annotation)
        let view = mapView.view(for: annotation)
        view?.prepareForDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
