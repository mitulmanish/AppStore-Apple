

import UIKit
import Foundation

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	var app: App? {
		didSet {
			if let appId = app?.id {
				let urlString = "http://www.statsallday.com/appstore/appdetail?id=\(appId)"
				if let url = URL(string: urlString) {
					let urlRequest: URLRequest = URLRequest(url: url)
					URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
						if let error = error {
							print(error.localizedDescription)
							return
						}
						
						if let data = data {
							do {
								if let dataDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
									print(dataDictionary)
									let newApp = App()
									newApp.setValuesForKeys(dataDictionary)
									self.app = newApp
									
									DispatchQueue.main.async {
										self.collectionView?.reloadData()
									}
								}
							} catch {
								
							}
						}
					}).resume()
				}
			}
		}
	}
	fileprivate let footerId = "footerId"
	fileprivate let headerId = "headerId"
	fileprivate let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.alwaysBounceVertical = true
		collectionView?.backgroundColor = UIColor.white
		collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
		collectionView?.register(FooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
		collectionView?.register(DetailImageCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionElementKindSectionFooter {
			let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
			return footer
		}
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
		header.app = self.app
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 170)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 250)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailImageCell
		cell.app = self.app
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 150)
	}
}

class AppDetailHeader: BaseCell {
	var app: App? {
		didSet {
			if let image = app?.imageName {
				headerImageView.image = UIImage(named: image)
			}
			
			if let appName = app?.name {
				headerLabel.text = appName
			}
			
			if let appCategory = app?.category {
				headerDescription.text = appCategory
			}
		}
	}
	
	let headerImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 16
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "telepaint")
		return imageView
	}()
	
	let headerLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16)
		label.text = "Try me out name is even bigger very long hhhhhhh"
		label.numberOfLines = 2
		return label
	}()
	
	let headerDescription: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 9)
		label.text = "This is a description"
		label.textColor = UIColor.gray
		label.numberOfLines = 2
		return label
	}()
	
	let headerSegmentedControl: UISegmentedControl = {
		let segmentedControl = UISegmentedControl(items: ["Details", "Reviews", "Related"])
		segmentedControl.tintColor = UIColor.gray
		segmentedControl.selectedSegmentIndex = 0
		return segmentedControl
	}()
	
	let buyButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("BUY", for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		button.layer.borderColor = UIColor(colorLiteralRed: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 5
		return button
	}()
	
	let divider: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
		return view
	}()
	
	override func setupViews() {
		super.setupViews()
		addSubview(headerImageView)
		addSubview(headerLabel)
		addSubview(headerDescription)
		addSubview(headerSegmentedControl)
		addSubview(buyButton)
		addSubview(divider)
		
		headerLabel.sizeToFit()
		headerDescription.sizeToFit()
	
		addConstraintsWithFormat("H:|-14-[v0(100)]-4-[v1]-4-|", views: headerImageView, headerLabel)
		addConstraintsWithFormat("V:|-14-[v0(100)]", views: headerImageView)
		addConstraintsWithFormat("V:|-14-[v0]", views: headerLabel, headerDescription)
		addConstraintsWithFormat("H:[v0]-14-|", views: buyButton)
		addConstraintsWithFormat("H:|[v0]|", views: divider)
		addConstraintsWithFormat("V:[v0(0.5)]|", views: divider)
		
		addConstraint(NSLayoutConstraint(item: headerDescription, attribute: .top, relatedBy: .equal, toItem: headerLabel, attribute: .bottom, multiplier: 1, constant: 2))
		
		addConstraint(NSLayoutConstraint(item: headerDescription, attribute: .left, relatedBy: .equal, toItem: headerImageView, attribute: .right, multiplier: 1, constant: 6))
		addConstraint(NSLayoutConstraint(item: headerDescription, attribute: .right, relatedBy: .equal, toItem: self, attribute: .rightMargin, multiplier: 1, constant: 4))
		
		// Segmented Control
		addConstraint(NSLayoutConstraint(item: headerSegmentedControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
		addConstraintsWithFormat("H:|-14-[v0]-14-|", views: headerSegmentedControl)
		addConstraintsWithFormat("V:[v0]-8-|", views: headerSegmentedControl)
		
		addConstraint(NSLayoutConstraint(item: buyButton, attribute: .bottom, relatedBy: .equal, toItem: headerImageView, attribute: .bottom, multiplier: 1, constant: 0))
		addConstraint(NSLayoutConstraint(item: buyButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60))
		addConstraint(NSLayoutConstraint(item: buyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
	}
}

extension UIView {
	
	func addConstraintsWithFormat(_ format: String, views: UIView...) {
		var viewsDictionary = [String: UIView]()
		for (index, view) in views.enumerated() {
			let key = "v\(index)"
			viewsDictionary[key] = view
			view.translatesAutoresizingMaskIntoConstraints = false
		}
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
	}
	
}

class BaseCell: UICollectionViewCell {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupViews() {
		
	}
}
