//
//  secondViewController.swift
//  Top Stories
//
//  Created by apcs2 on 2/20/18.
//  Copyright © 2018 apcs2. All rights reserved.
//

import UIKit
import SafariServices

class secondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var mySecondTableView: UITableView!
    
    var articles = [[String : String]]()
    var api = ""
    var source = [String : String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Top Stories"
        let query = "https://newsapi.org/v1/articles?source=\(source["id"]!)&apiKey=\(api)"
        DispatchQueue.global(qos: .userInitiated).async
            {
                [unowned self] in
                if let url = URL(string: query)
                {
                    if let data = try? Data(contentsOf: url)
                    {
                        let json = try! JSON(data: data)
                        if json["status"] == "ok"
                        {
                            self.parse(json: json)
                            return
                        }
                    }
                }
                self.loadError()
        }
    }
    
    
    func parse(json: JSON)
    {
        DispatchQueue.main.async
            {
                [unowned self] in
                for i in json["articles"].arrayValue
                {
                    let title = i["title"].stringValue
                    let url = i["url"].stringValue
                    let description = i["description"].stringValue
                    let article = ["title" : title, "url": url, "description": description]
                    self.articles.append(article)
                }
                self.mySecondTableView.reloadData()
        }
    }
    
    func loadError()
    {
        DispatchQueue.main.async
        {
                [unowned self] in
                let alert = UIAlertController(title: "loading error", message: "fake news", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let url = URL(string: articles[indexPath.row]["url"]!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = mySecondTableView.dequeueReusableCell(withIdentifier: "myOtherCell")
        let article = articles[indexPath.row]
        cell?.textLabel?.text = article["title"]
        cell?.detailTextLabel?.text = article["description"]
        return cell!
    }
}
