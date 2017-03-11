//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

//Make the playground work with RxSwift
PlaygroundPage.current.needsIndefiniteExecution = true

//Make URLSession correctly working DISABLE CACHE
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

typealias JSONDictionary = [String: Any]

enum Errors: Error {
    
    case wrongUrl(String)
    case invalidData(Any,String)
    case keyInJsonNotFound(String)
    
}

//GETTING profile from GITHUB
func fetchProfile(username: String, onCompletion: @escaping (JSONDictionary) -> Void, onError: @escaping (Error) -> Void){
    
    let urlString = "https://api.github.com/users/\(username)"
    
    guard let url = URL.init(string: urlString) else {
        onError(Errors.wrongUrl(urlString))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
        guard let httpResponse = response as? HTTPURLResponse else {
            fatalError("Unsupported protocol!!")
        }
        
        if !(200..<300 ~= httpResponse.statusCode) {
            onError(Errors.wrongUrl(httpResponse.description))
        }
        
        if let error = error {
            onError(error)
        }else{
            if let data = data {
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    onError(Errors.invalidData(data,"Serialize json"))
                    return
                }
                guard let profile = json as? JSONDictionary else {
                    onError(Errors.invalidData(data,"Not a profile"))
                    return
                }
                
                onCompletion(profile)
            }
        }
        
    }
    
    task.resume()
    
}

//fetchProfile(username: "eriscoand", onCompletion: { print($0) }, onError: { print($0) })

//FETCH Image from string url
func fetchImage(urlString: String, onCompletion: @escaping (UIImage) -> Void, onError: @escaping (Error) -> Void ){
    
    guard let url = URL.init(string: urlString) else {
        onError(Errors.wrongUrl(urlString))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
        guard let httpResponse = response as? HTTPURLResponse else {
            fatalError("Unsupported protocol!!")
        }
        
        if !(200..<300 ~= httpResponse.statusCode) {
            onError(Errors.wrongUrl(httpResponse.description))
        }
     
        if let error = error {
            onError(error)
        }else{
            if let data = data {
                guard let image = UIImage(data: data) else {
                    onError(NSError(domain: "Error downloading image", code: 0, userInfo: nil))
                    return
                }
                onCompletion(image)
            }
        }
        
    }
    
    task.resume()
    
}

let urlString = "http://traffic-safety.ohio.aaa.com/wp-content/uploads/2016/02/google-play-badge1.png"
fetchImage(urlString: urlString, onCompletion: { let image = UIImageView(image: $0)  } , onError: { print($0) } )


func fetchAvatarImage(username: String, onCompletion: @escaping (UIImage) -> Void, onError: @escaping (Error) -> Void ){

    fetchProfile(username: username, onCompletion: { (profile: JSONDictionary) in
        
        guard let urlString = profile["avatar_url"] as? String else {
            onError(Errors.keyInJsonNotFound("avatar_url"))
            return
        }
        
        fetchImage(urlString: urlString, onCompletion: { (image: UIImage) in
            onCompletion(image)
        },
        onError: { onError($0) })
        
    }, onError: { onError($0) } )
    
}

fetchAvatarImage(username: "eriscoand", onCompletion: { let image = UIImageView(image: $0) }, onError: { print($0) } )








