//
//  DetailImageCell.swift
//  AppStore-Apple
//
//  Created by LIFX Laptop on 28/4/17.
//  Copyright © 2017 LIFX Laptop. All rights reserved.
//

import Foundation
import UIKit

class DetailImageCell: BaseCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var app: App? {
		didSet {
			imageCollectionView.reloadData()
		}
	}
	let screenShotImageCell = "screenShotImageCell"
	
	var imageCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = UIColor.clear
		return cv
	}()
	
	override func setupViews() {
		super.setupViews()
		imageCollectionView.delegate = self
		imageCollectionView.dataSource = self
		
		addSubview(imageCollectionView)
		addConstraintsWithFormat("H:|[v0]|", views: imageCollectionView)
		addConstraintsWithFormat("V:|[v0]|", views: imageCollectionView)
		imageCollectionView.register(ScreenShotImageCell.self, forCellWithReuseIdentifier: screenShotImageCell)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return app?.screenshots?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenShotImageCell, for: indexPath) as! ScreenShotImageCell
		if let imageName = app?.screenshots?[indexPath.item] {
			cell.imageView.image = UIImage(named: imageName)
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 200, height: frame.height - 28)
	}

}

class ScreenShotImageCell: BaseCell {
	
	var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		//imageView.image = UIImage(named: "frozen_screenshot1")
		return imageView
	}()
	
	override func setupViews() {
		super.setupViews()
		addSubview(imageView)
		addConstraintsWithFormat("V:|[v0]|", views: imageView)
		addConstraintsWithFormat("H:|[v0]|", views: imageView)
	}
}
