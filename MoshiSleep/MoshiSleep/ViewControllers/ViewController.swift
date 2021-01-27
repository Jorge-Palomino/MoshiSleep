//
//  ViewController.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let loadingCellId = "loadingCell"
    let weatherCellId = "weatherCell"
    
    var cityWeathers: [CityWeather] = []
    var isLoading: Bool = true
    var previousSearchText: String = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.barStyle = .black
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search city"
        navigationItem.searchController = search
        
        title = "Cities Weather"
        view.backgroundColor = .clear
        view.setGradientBackground(colorTop: .darkBackground, colorBottom: .lightBackground, direction: .topToBottom)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        tableView.register(LoadingTableCell.self, forCellReuseIdentifier: loadingCellId)
        tableView.register(WeatherCell.self, forCellReuseIdentifier: weatherCellId)
        
        reloadData()
        
        // 3D TOUCH
        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    @objc func reloadData() {
        self.isLoading = true
        var ids: [String] = []
        if let cities = U.getCurrentWeathers() {
            cities.forEach { ids.append( String($0.id) )}
        }else {
            ids = C.cityIds
        }
        C.networkManager.getGroupWeather(for: ids) { weathers, error in
            DispatchQueue.main.async {
                if let weathers = weathers {
                    self.cityWeathers = weathers
                    U.saveCurrentCities(cities: self.cityWeathers)
                }else {
                    self.cityWeathers = U.getCurrentWeathers() ?? []
                }
                self.isLoading = false
                UIView.transition(with: self.tableView, duration: 0.35, options: [.allowUserInteraction, .transitionCrossDissolve], animations: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.view.removeGradient()
            self.view.setGradientBackground(colorTop: .darkBackground, colorBottom: .lightBackground, direction: .topToBottom)
            UIView.transition(with: self.tableView, duration: 0.35, options: [.allowUserInteraction, .transitionCrossDissolve], animations: {
                self.tableView.reloadData()
            })
        })
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        }
        return cityWeathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellId, for: indexPath) as! LoadingTableCell
            cell.spinner.startAnimating()
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherCellId, for: indexPath) as! WeatherCell
        
        let weather = cityWeathers[indexPath.row]
        cell.configure(weather)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController")
          as? DetailViewController else {
          assertionFailure("No view controller ID DetailViewController in storyboard")
          return
        }
        vC.cityWeather = cityWeathers[indexPath.row]
        vC.delegate = self
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading {
            return 300
        }
        return 70
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if previousSearchText != text {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchCity(_:)), object: searchController.searchBar)
            perform(#selector(self.searchCity(_:)), with: searchController.searchBar, afterDelay: 0.75)
        }
    }
    
    @objc func searchCity(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        
        previousSearchText = searchText

        C.networkManager.cancelRequest()
        C.networkManager.getWeather(for: searchText) { response, error in
            DispatchQueue.main.async {
                if let weather = response {
                    guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController")
                      as? DetailViewController else {
                        fatalError("Couldn't load detail view controller")
                    }
                    vc.cityWeather = weather
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if let err = error {
                    U.showAlertMessage(superview: self.view, alertType: .error, alerText: err, timeout: 2.5)
                }
            }
        }
    }
}

extension ViewController: UIViewControllerPreviewingDelegate {
    
    func detailViewController(for index: Int) -> DetailViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController")
          as? DetailViewController else {
            fatalError("Couldn't load detail view controller")
        }
        let weather = cityWeathers[index]
        vc.cityWeather = weather
        vc.delegate = self
        vc.preferredContentSize = CGSize(width: 0.0, height: 255)
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            return detailViewController(for: indexPath.row)
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
