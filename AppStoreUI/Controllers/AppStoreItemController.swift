//
//  AppStoreItemController.swift
//  AppStoreUI
//
//  Created by Md. Saber Hossain on 22/1/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class AppStoreItemController {
    
    struct Response<T : Codable> : Codable {
       
        let data : T
        
        private enum CodingKeys: String, CodingKey{
            case data
        }
    }
    
    struct AppStoreItemSection : Hashable, Codable{
        let title: String?
        let subtitle: String?
        let items : [AppStoreItem]
        let identifier = UUID()
       
        func hash(into haser: inout Hasher) {
            haser.combine(identifier)
        }
        
        private enum CodingKeys: String, CodingKey{
            case title, subtitle, items
        }
        
        var isFeaturedSection : Bool{
            return title == nil && subtitle == nil
        }
    }
    
    struct AppStoreItem: Hashable, Codable {
        let hint : String?
        let title : String
        let description : String
        let imageURL : String?
        let inAppPurchasable : Bool
        let identifier = UUID()
        
        private enum CodingKeys: String, CodingKey{
            case hint, title, description
            case imageURL = "image_url"
            case inAppPurchasable = "in_app_purchasable"
        }
        
        func hash(into hasher: inout Hasher){
            hasher.combine(identifier)
        }
    }
    
    fileprivate var _collections = [AppStoreItemSection]()
   
    var collections: [AppStoreItemSection]{
        return _collections
    }
    
    init() {
        createCollection()
    }
}

extension AppStoreItemController {
   
    func createCollection(){
        _collections = []
        guard let fileURL = Bundle.main.url(forResource: "AppStoreContent", withExtension: "json")  else { return }
        guard let jsonData = try? Data(contentsOf: fileURL) else { return }
       
        do{
            let response = try JSONDecoder().decode(Response<[AppStoreItemSection]>.self, from: jsonData)
            _collections = response.data
        }catch(let error){
            print(error.localizedDescription)
        }
       
    }
}
