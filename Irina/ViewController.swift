//
//  ViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 29/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData


class irinaApi {
    func searchMovies(search:String, completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        let url: NSURL = NSURL(string: "https://api.betaseries.com/movies/search?title=\(search)&key=14cbb71a3f03")!
        let ses = NSURLSession.sharedSession()
        let task = ses.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
            }
            
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)as! NSDictionary
            
            if (error != nil) {
                return completionHandler(nil, error)
            } else {
                return completionHandler(json["movies"] as! [NSDictionary], nil);
            }
        })
        task.resume()
    }
    
    func showMovie(id:Int, completionHandler: ((NSDictionary!, NSError!) -> Void)!) -> Void {
        let url: NSURL = NSURL(string: "https://api.betaseries.com/movies/movie?id=\(id)&key=14cbb71a3f03")!
        let ses = NSURLSession.sharedSession()
        let task = ses.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
            }
            
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)as! NSDictionary
            
            if (error != nil) {
                return completionHandler(nil, error)
            } else {
                return completionHandler(json["movie"] as! NSDictionary, nil);
            }
        })
        task.resume()
    }
    
    
}

var irina = irinaApi();
var moviesToWatch = [];
var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
var context:NSManagedObjectContext = appDel.managedObjectContext!

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
}

