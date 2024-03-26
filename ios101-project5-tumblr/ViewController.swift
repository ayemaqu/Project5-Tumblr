//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    
    //Add table view outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    // Array to store fetched posts
    private var posts: [Post] = []
    private var refreshControl = UIRefreshControl()
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        tableView.dataSource = self
    //
    //
    //        fetchPosts()
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        
        // Add refresh control to table view
        tableView.addSubview(refreshControl)
        
        tableView.dataSource = self
        
        fetchPosts()
    }
    
    @objc private func refreshFeed() {
        // Call your fetchPosts method to reload the data
        fetchPosts()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("🍏 cellForRowAt called for row: \(indexPath.row)")
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tumblrCell", for: indexPath) as! tumblrCell
        
        // Get the post associated with the current row
        let post = posts[indexPath.row]
        
        // Set the overview label text to the post summary
        cell.overviewLabel?.text = post.summary
        
        // Load the photo in the image view via Nuke library if post has photos
        if let photo = post.photos.first {
            let url = photo.originalSize.url
            if let tumblrImageView = cell.tumblrImageView {
                Nuke.loadImage(with: url, into: tumblrImageView)
            } else {
                print("Error: tumblrImageView is nil")
            }
        }
        
        
        // Return the cell for use in the respective table view row
        return cell
    }
    
    
    
    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("❌ Data is NIL")
                return
            }
            
            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                
                DispatchQueue.main.async {
                    // Capture self explicitly to avoid the error
                    self.posts = blog.response.posts
                    self.tableView.reloadData()
                    
                    print("🍏 Fetched and stored \(self.posts.count) posts")
                    
                    let posts = blog.response.posts
                    
                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                    
                    // End refreshing
                    self.refreshControl.endRefreshing()
                }
                
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
