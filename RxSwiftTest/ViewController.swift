//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by Joonhwan Jeon on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var todos = [String]()
    var todosRelay = BehaviorRelay(value: [String]())
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        
        self.bindToRx()
    }
    
    func bindToRx() {
        self.addButton.rx.tap.bind { [self] in
            guard inputText.text?.isEmpty == false else { return }
            
            todos.append(self.inputText.text!)
            todosRelay.accept(self.todos)
            inputText.text = ""
        }.disposed(by: self.disposeBag)
        
        self.todosRelay
            .bind(to: self.tableView.rx.items(cellIdentifier: "TodoCell")) {
                (index, todo: String, cell: UITableViewCell) in
                cell.textLabel?.text = todo
            }.disposed(by: self.disposeBag)
    }
}

