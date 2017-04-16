//
//  CategoryCell.swift
//  AppStore-Apple
//
//  Created by LIFX Laptop on 16/3/17.
//  Copyright © 2017 LIFX Laptop. All rights reserved.
//

import Foundation
import UIKit

class LargeCategoryCell: CategoryCell {
	
	override func setupViews() {
		super.setupViews()
		appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: "largeAppCell")
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeAppCell", for: indexPath) as! LargeAppCell
		cell.app = category?.apps?[indexPath.item]
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 200, height: frame.height - 2 - 30)
	}
	
	class LargeAppCell: AppCell {
		override func setupViews() {
			addSubview(imageView)
			imageView.translatesAutoresizingMaskIntoConstraints = false
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[v0]-2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
		}
	}
}

class HeaderCell: CategoryCell {
	
	var banner: Banner? = nil {
		didSet {
			appsCollectionView.reloadData()
		}
	}
	
	override func setupViews() {
		addSubview(appsCollectionView)
		appsCollectionView.delegate = self
		appsCollectionView.dataSource = self
		appsCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: "bannerCell")
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCell
		cell.imageView.image = UIImage(named: banner?.imageNames?[indexPath.item] ?? "")
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: frame.width, height: frame.height)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return banner?.imageNames?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0.0
	}
	
	override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets.zero
	}
	
	class BannerCell: AppCell {
		override func setupViews() {
			imageView.layer.cornerRadius = 0.0
			imageView.contentMode = .scaleAspectFit
			imageView.translatesAutoresizingMaskIntoConstraints = false
			addSubview(imageView)
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
		}
	}
}

class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	var featuredAppController: FeaturedAppsController?
	
    var category: AppCategory? {
        didSet {
            categoryHeading.text = category?.name
            appsCollectionView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AppCell.self, forCellWithReuseIdentifier: "appCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = category?.apps?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appCell", for: indexPath) as! AppCell
        cell.app = category?.apps?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: frame.height - 2 - 30)
    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let selectedApp = category?.apps?[indexPath.item] {
			featuredAppController?.presentAppDetail(app: selectedApp)
		}
	}
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let categoryHeading: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(appsCollectionView)
        addSubview(dividerView)
        addSubview(categoryHeading)
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": categoryHeading]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]-14-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dividerView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[categoryHeading(30)][v0]-1-[v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView, "v1": dividerView, "categoryHeading": categoryHeading]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
}

class AppCell: UICollectionViewCell {
    
    var app: App? {
        didSet {
            if let app = app {
                if let imageName = app.imageName {
                    print(imageName)
                    imageView.image = UIImage(named: imageName)
                }
                if let name = app.name {
                    _ = NSString(string: name).boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
                    nameLabel.text = app.name
                }
                categoryLabel.text = app.category
                if let price = app.price {
                    priceLabeL.text = "$ \(price.stringValue)"
                } else {
                    priceLabeL.text = ""
                }
            }
        }
    }
    let imageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFill
        im.layer.cornerRadius = 16.0
        im.layer.masksToBounds = true
        return im
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let priceLabeL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabeL)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 150.0)
        nameLabel.frame = CGRect(x: 0, y: imageView.frame.height + 2, width: frame.width, height: 30)
        categoryLabel.frame = CGRect(x: 0, y: imageView.frame.height + 2 + nameLabel.frame.height + 1, width: frame.width, height: 10)
        priceLabeL.frame = CGRect(x: 0, y: imageView.frame.height + 2 + nameLabel.frame.height + 1 + categoryLabel.frame.height + 2, width: frame.width, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
