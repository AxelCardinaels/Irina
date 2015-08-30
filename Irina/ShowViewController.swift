//
//  ShowViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 30/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    
    var idToShow = Int();
    var movie = NSDictionary();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        api.showMovie(idToShow, completionHandler: { (data, error) -> Void in
            
            if (data != nil) {
                println(data);
                self.movie = data
                println(self.movie)
                
            } else {
                println("api.showMovie failed")
                println(error)
            }
        })
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
