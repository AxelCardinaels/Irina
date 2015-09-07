//
//  SearchViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 29/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData


class SearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var movieTable: UITableView!
    var movies: NSMutableArray = [];
    var selectedMovie = NSDictionary();
    var searchBar = UISearchBar()
    
    
    //Mise en place de l'interface quand on clique sur la barre de recherche
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        if searchBar.text == ""{
            
            searchBar.setShowsCancelButton(true, animated: true)
            
        }
        
    }
    
    
    //Quand la valeur du champ de recherche change, on lance la rehcerche
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""{
            
            
        }else{
            let searchString = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+");
            irina.searchMovies(searchString, completionHandler: {data, error -> Void in
                
                if (data != nil) {
                    self.movies = NSMutableArray(array: data);
                    println(self.movies)
                    dispatch_async(dispatch_get_main_queue(), { self.movieTable.reloadData() })
                } else {
                    println("api.getData failed")
                    println(error)
                }
            })
        }
        
        
    }
    
    
    //On lance la recherche au click sur le bouton "rechercher"
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true);
        
        if searchBar.text == ""{
            
        }else{
            let searchString = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+");
            irina.searchMovies(searchString, completionHandler: {data, error -> Void in
                
                if (data != nil) {
                    self.movies = NSMutableArray(array: data);
                    dispatch_async(dispatch_get_main_queue(), { self.movieTable.reloadData() })
                } else {
                    println("api.getData failed")
                    println(error)
                }
            })
        }
    }
    
    //Suppression du bouton cancel + bouton suivi activé de nouveau au click sur le bouton annuler de la bar
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true);
        searchBar.setShowsCancelButton(false, animated: true);
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        //Mise en place de la barre de recherche dans la bar de navigation
        
        var colorTextSearchBar = searchBar.valueForKey("searchField") as? UITextField
        colorTextSearchBar?.textColor = UIColor.whiteColor()
        searchBar.sizeToFit()
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.placeholder = "Rechercher un film"
        self.navigationItem.titleView = searchBar;
        addBlurEffect(self);
        
        
        searchBar.keyboardType = UIKeyboardType.WebSearch
        searchBar.delegate = self;
        
        // Do any additional setup after loading the view.
        
        movieTable.rowHeight = UITableViewAutomaticDimension
        movieTable.estimatedRowHeight = 77.0;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell
        
        if let actualMovie = self.movies[indexPath.row]["title"] as? NSString {
            
            cell.movieTitle?.text = actualMovie as? String
        } else {
            cell.movieTitle?.text = "No Name"
        }
        
        cell.movieTitle?.numberOfLines = 0;
        cell.movieTitle?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        
        cell.movieType.text = "Action & Horreur";
        cell.movieRate.text = "8/10";
        
        
        
        
        cell.backgroundColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 0.0);
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMovie = movies[indexPath.row] as! NSDictionary
        performSegueWithIdentifier("showMovie", sender: AnyObject?())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMovie" {
            var secondView: ShowViewController = segue.destinationViewController as! ShowViewController
            
            secondView.idToShow = (selectedMovie["id"] as? Int)!;
            secondView.title = selectedMovie["title"] as? String;
            secondView.local = false;
            
            
        }
        
    }
    
    
    
}
