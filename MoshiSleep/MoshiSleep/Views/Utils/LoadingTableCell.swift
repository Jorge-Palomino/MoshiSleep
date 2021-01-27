//
//  LoadingTableCell.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation
import UIKit

class LoadingTableCell: UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        backgroundColor = .clear
        
        contentView.addSubview(spinner)
        
        [
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ].forEach { $0.isActive = true }
        
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
