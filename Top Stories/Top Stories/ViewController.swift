//
//  ViewController.swift
//  Top Stories
//
//  Created by apcs2 on 2/20/18.
//  Copyright © 2018 apcs2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var myTableView: UITableView!
    
    var sources = [[String : String]]()
    

    let apiKey = "5d892509a49046a087917c466fa80d09"

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.title = "News Sources"
        let query = "https://newsapi.org/v1/sources?language=en&country=us&apiKey=\(apiKey)"
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
            for i in json["sources"].arrayValue
            {
                let id = i["id"].stringValue
                let name = i["name"].stringValue
                let description = i["description"].stringValue
                let source = ["id" : id, "name": name, "description": description]
                self.sources.append(source)
            }
            self.myTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell")
        let source = sources[indexPath.row]
        cell?.textLabel?.text = source["name"]
        cell?.detailTextLabel?.text = source["description"]
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let nvc = segue.destination as! secondViewController
        let index = myTableView.indexPathForSelectedRow?.row
        nvc.source = sources[index!]
        nvc.api = apiKey
    }
    
}
