//
//  FooterCell.swift
//  AppStore-Apple
//
//  Created by LIFX Laptop on 29/4/17.
//  Copyright © 2017 LIFX Laptop. All rights reserved.
//

import Foundation
import UIKit

class FooterCell: BaseCell, UITableViewDelegate, UITableViewDataSource {
	
	let tableCell = "tablecell"
	var tableView: UITableView = {
		let style = UITableViewStyle(rawValue: 0)
		let tb = UITableView(frame: .zero, style: style!)
		return tb
	}()
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath) as! CustomFooterCell
		return cell
	}
	override func setupViews() {
		super.setupViews()
		backgroundColor = UIColor.yellow
		addSubview(tableView)
		tableView.register(CustomFooterCell.self, forCellReuseIdentifier: tableCell)
		tableView.delegate = self
		tableView.dataSource = self
		
		addConstraintsWithFormat("H:|[v0]|", views: tableView)
		addConstraintsWithFormat("V:|[v0]|", views: tableView)
	}
}

class CustomFooterCell: UITableViewCell {
	
	var footerLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "See"
		label.textColor = UIColor(colorLiteralRed: 0, green: 129/255, blue: 250/255, alpha: 1)
		return label
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		addSubview(footerLabel)
		accessoryType = .disclosureIndicator
		selectionStyle = .none
		addConstraint(NSLayoutConstraint(item: footerLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
		addConstraint(NSLayoutConstraint(item: footerLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
	}
}


