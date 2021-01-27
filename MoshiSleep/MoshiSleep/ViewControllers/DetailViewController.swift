//
//  DetailViewController.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cityWeather: CityWeather?
    let weatherDetailCellId = "weatherDetailCell"
    let mapCellId = "mapCell"
    
    var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let menuButton = U.barImageView(imageName: "icon-back", selector: #selector(goBack), target: self)
        navigationItem.leftBarButtonItems = [menuButton]
        var likeButton: UIBarButtonItem!
        if delegate?.cityWeathers.firstIndex(where: { $0.id == cityWeather?.id }) != nil {
            likeButton = U.barImageView(imageName: "icon-like-filled", selector: #selector(likeCity), target: self, frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        }else {
            likeButton = U.barImageView(imageName: "icon-like", selector: #selector(likeCity), target: self, frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        }
        navigationItem.rightBarButtonItems = [likeButton]
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        view.backgroundColor = .clear
        
        if let weather = cityWeather?.weather.first {
            view.setGradientBackground(colorTop: weather.main.getLightColor(), colorBottom: weather.main.getDarkColor(), direction: .topToBottom)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "WeatherDetailCell", bundle: nil), forCellReuseIdentifier: weatherDetailCellId)
        tableView.register(MapCell.self, forCellReuseIdentifier: mapCellId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func likeCity() {
        var likeButton: UIBarButtonItem!
        if let index = delegate?.cityWeathers.firstIndex(where: { $0.id == cityWeather?.id }) {
            delegate?.cityWeathers.remove(at: index)
            likeButton = U.barImageView(imageName: "icon-like", selector: #selector(likeCity), target: self, frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        }else if let city = cityWeather {
            delegate?.cityWeathers.append(city)
            likeButton = U.barImageView(imageName: "icon-like-filled", selector: #selector(likeCity), target: self, frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        }
        DispatchQueue.main.async {
            self.delegate?.tableView.reloadData()
        }
        U.saveCurrentCities(cities: delegate?.cityWeathers)
        navigationItem.rightBarButtonItems = [likeButton]
        
        navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform.identity
        navigationItem.rightBarButtonItem?.customView?.layer.add(U.bounceAnimation, forKey: nil)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.view.removeGradient()
            if let weather = self.cityWeather?.weather.first {
                self.view.setGradientBackground(colorTop: weather.main.getLightColor(), colorBottom: weather.main.getDarkColor(), direction: .topToBottom)
            }
            self.tableView.reloadData()
        })
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: weatherDetailCellId, for: indexPath) as! WeatherDetailCell
            if cityWeather != nil {
                cell.configure(with: cityWeather!)
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: mapCellId, for: indexPath) as! MapCell
            if cityWeather != nil {
                cell.configure(with: cityWeather!)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        
        if row == 0 {
            return 240
        }else {
            return 160
        }
    }
}
