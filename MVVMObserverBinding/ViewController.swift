//
//  ViewController.swift
//  MVVMBindings
//
//  Created by Umair on 21/08/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView : UITableView = {
        let table = UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var viewModel = UserListVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        self.tableView.frame = view.bounds
        self.tableView.dataSource = self
        
        viewModel.users.bind { [weak self] usersTVCVMList in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.users.value?[indexPath.row].name
        return cell
    }
    
    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let usersModel = try JSONDecoder().decode([UserM].self, from: data)
                self.viewModel.users.value = usersModel.compactMap({
                    UserTVCellVM(name: $0.name)
                })
                
                //just to show a simple example that how message binding works...
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) { [weak self] in
                    let _ = usersModel.map ({
                        self?.viewModel.users.value?.append(UserTVCellVM(name: $0.name))
                    })
                }
                
            } catch {
                
            }
        }
        task.resume()
    }
    
    
}

