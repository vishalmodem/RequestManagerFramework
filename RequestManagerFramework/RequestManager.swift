//
//  File.swift
//  RequestManagerFramework
//
//  Created by vishal modem on 6/28/18.
//  Copyright © 2018 vishal modem. All rights reserved.
//

import Foundation

private enum RequestCreator{
    case get
    case post(Actor)
    case update(Actor)
    case delete(Actor)
    
    static let baseURl = "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors"
    
    private var method : String{
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .update:
            return "UPDATE"
        case .delete:
            return "DELETE"
        }
    }
    
    public func urlRequest() -> URLRequest {
        let url : URL = {
            let relativePath : String?
            switch self {
            case .get, .post:
                relativePath = nil
            case .update(let actor), .delete(let actor):
                relativePath = "\(actor)"
            }
            var url = URL(string: RequestCreator.baseURl)!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            return url
        }()
        
         let parameters : Actor? = {
            switch self {
            case .get, .delete :
                return nil
            case .post(let actor), .update(let actor):
                return actor
            }
        }()
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        guard let actor = parameters else {
            return request
        }
        let encoder = JSONEncoder()
        do{
            let data =  try encoder.encode(actor)
            request.httpBody = data
        } catch{
            print(error.localizedDescription)
        }
        
        return request
    }
}
public class RequestManager {
    static let shared = RequestManager()
    public func getActorsData(_ completion: @escaping ([Actor])->()){
        makeRequest(request: RequestCreator.get) { (actors) in
            completion(actors)
        }
    }
    public func postAnActor(actor : Actor){
        makeRequest(request: RequestCreator.post(actor)) { (actors) in
            
        }
    }
    public func updateAnActor(actor : Actor){
        makeRequest(request: RequestCreator.update(actor)) { (actors) in
            
        }
        
    }
    public func deleteAnActor(actor : Actor){
        makeRequest(request: RequestCreator.delete(actor)) { (actors) in
            
        }
        
    }
    
    
    private func makeRequest(request : RequestCreator,_ completion: @escaping ([Actor])->()) {
        var actors: [Actor]?
        let requestObject = request.urlRequest()
        URLSession.shared.dataTask(with: requestObject){ (data, response, error) in
            guard let info = data, error == nil, response != nil else{
                print(error?.localizedDescription)
                return
            }
            //print(String(data: info, encoding: String.Encoding.utf8))
            let decoder = JSONDecoder()
            do {
                let  downloadedActors = try decoder.decode(Actors.self, from: info)
                guard let allActors = downloadedActors.actors else{
                    return
                }
                actors = [Actor]()
                for actor in allActors{
                    let a = Actor(name: actor.name!, image: actor.image!)
                    actors?.append(a)
                }
                guard let actors = actors else{return}
                completion(actors)
            } catch{
                print(error.localizedDescription)
            }
            }.resume()
    }
    
}
