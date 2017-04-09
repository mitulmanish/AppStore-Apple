//
//  ViewController.swift
//  AppStore-Apple
//
//  Created by LIFX Laptop on 14/3/17.
//  Copyright © 2017 LIFX Laptop. All rights reserved.
//

import UIKit

class FeaturedAppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categories: [AppCategory] = []
	var bannerContent: Banner?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "cellId")
		collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: "largeCategoryCell")
		collectionView?.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        //categories = AppCategory.samples()
        AppCategory.fetchFeaturedApps { (appCategories, banner) in
            self.categories = appCategories
			self.bannerContent = banner
            self.collectionView?.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.item == 2 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCategoryCell", for: indexPath) as! LargeCategoryCell
			cell.category = categories[indexPath.item]
			return cell
		}
		
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CategoryCell
        cell.category = categories[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if indexPath.item == 2 {
			return CGSize(width: view.frame.width, height: 160)
		}
        return CGSize(width: view.frame.width, height: 240)
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 150)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCell
		headerCell.banner = bannerContent
		return headerCell
	}
}

