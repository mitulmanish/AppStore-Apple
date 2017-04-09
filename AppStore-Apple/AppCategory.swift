//
//  AppCategory.swift
//  AppStore-Apple
//
//  Created by LIFX Laptop on 23/3/17.
//  Copyright © 2017 LIFX Laptop. All rights reserved.
//

import Foundation

class AppCategory: NSObject {
    var name: String?
    var apps: [App]?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            self.apps = [App]()
            if let appdictionaries = value as? [[String: Any]] {
                for dictionary in appdictionaries {
                    let app = App()
                    app.setValuesForKeys(dictionary)
                    apps?.append(app)
                }
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchFeaturedApps(completionHandler: @escaping ([AppCategory], Banner?) -> ()) {
        let urlString = "http://www.statsallday.com/appstore/featured"
        if let url = URL(string: urlString) {
            print("Yay")
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                var appCategories = [AppCategory]()
                if let data = data {
                    //print(String(data: data, encoding: String.Encoding.utf8) ?? "Error")
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                        if let dictionary = jsonDictionary {
                            if let categories = dictionary["categories"] as? [[String: Any]] {
                                for category in categories {
                                    let appCategory = AppCategory()
                                    appCategory.setValuesForKeys(category)
                                    appCategories.append(appCategory)
                                }
                            } else {
                                appCategories = []
                            }
							var banner: Banner?
							if let bannerCategory = dictionary["bannerCategory"] as? [String: Any] {
								print(bannerCategory)
								banner = Banner(data: bannerCategory)
							}
                            
                            DispatchQueue.main.async {
                                completionHandler(appCategories, banner)
                            }
                            
                        }
                    } catch let jsonError {
                        print(jsonError.localizedDescription)
                    }
                    
                }
            }.resume()
        } else {
            print("Cant form URL")
        }
    }
}

class App: NSObject {
    var name: String?
    var id: NSNumber?
    var category: String?
    var imageName: String?
    var price: NSNumber?
    
    override init() {
        
    }
    
    init(name: String, id: NSNumber, category: String, imageName: String, price: NSNumber) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.imageName = imageName
    }
}

class Banner: NSObject {
	let imageNames: [String]? = []
	
	init?(data: [String: Any]) {
		guard let appsCollection = data["apps"] as? [[String: Any]]  else {
			return nil
		}
		for app in appsCollection {
			if let imageName = app["ImageName"] as? String {
				imageNames?.append(imageName)
			}
		}
	}
}
