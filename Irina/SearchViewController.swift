//
//  SearchViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 29/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit

class RemoteAPI {
    func getData(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        let url: NSURL = NSURL(string: "https://api.betaseries.com/movies/search?title=mission&key=14cbb71a3f03")!
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
}

var api = RemoteAPI();


class SearchViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var movieTable: UITableView!
    var items: NSMutableArray = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        api.getData({data, error -> Void in
            
            if (data != nil) {
                self.items = NSMutableArray(array: data);
                dispatch_async(dispatch_get_main_queue(), { self.movieTable.reloadData() })
            } else {
                println("api.getData failed")
                println(error)
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        if let navn = self.items[indexPath.row]["title"] as? NSString {
            
            cell.textLabel?.text = navn as? String
        } else {
            cell.textLabel?.text = "No Name"
        }
        
        
        return cell
    }
    
    
    
}
