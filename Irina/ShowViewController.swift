//
//  ShowViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 30/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData

class ShowViewController: UIViewController {
    
    var idToShow = Int();
    var movie = NSDictionary();
    
    
    func makeAddButton(){
        var addButton : UIBarButtonItem = UIBarButtonItem(title: "À regarder", style: UIBarButtonItemStyle.Plain, target: self, action: "addMovie")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func addMovie(){

        
        var newMovie = NSEntityDescription.insertNewObjectForEntityForName("Movie", inManagedObjectContext: context) as! NSManagedObject;
        
        newMovie.setValue(movie["title"] as! String, forKey: "title");
        context.save(nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        irina.showMovie(idToShow, completionHandler: { (data, error) -> Void in
            
            if (data != nil) {
                self.movie = data
                
            } else {
                println("api.showMovie failed")
                println(error)
            }
        })
        
        makeAddButton();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
