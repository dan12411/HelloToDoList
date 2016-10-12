//
//  ViewController.swift
//  HelloToDoList
//
//  Created by 洪德晟 on 2016/10/12.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var toDoArray = [String]()
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        // 使用我們寫好的函式
        askInfoWithDefault(nil) {
            (sucess: Bool, toDo: String?) in
            
            // 如果成功有輸入文字的話
            if sucess == true {
                if let okToDo = toDo {
                    
                    // 把待辦事項存到okToDo 加到toDoArray & reload
                    self.toDoArray.append(okToDo)
                    self.myTableView.reloadData()
                    
                    // Save to UserDefaults & 同步
                    UserDefaults.standard.set(self.toDoArray, forKey: "toDo")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    // 給 completion 取小名
    typealias AskInfoCompletion = (Bool,String?) -> ()
    
    // Alert (*@escaping)
    func askInfoWithDefault(_ defaultToDo: String?, withCompletionHandler completion: @escaping AskInfoCompletion) {
        let myAlert = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        
        // 新增文字輸入框並設定參數
        myAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Add New Task Here"   // 設定文字輸入框的placeholder
            textField.text = defaultToDo  // 如果有預設文字，顯示預設文字
        }
        
        // OK Button
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in
            
            // 拿到使用者輸入在第一個文字輸入框內的文字(textFields是Array)
            let inputText = myAlert.textFields?[0].text
            
            if inputText != nil && inputText != "" {
                // 使用者真的有輸入文字
                completion(true, inputText)
            } else {
                // 沒有輸入文字
                completion(false, nil)
            }
        }
        
        // Cancel Button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            (action) in
            completion(false, nil)
        }
        
        // Add Button
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        
        // Present
        present(myAlert, animated: true, completion: nil)
    }


    // Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        return cell
    }
    
    // 按下 i 之後要修改 toDo
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // 找到按下的文字
        let thisToDo = toDoArray[indexPath.row]
        // 用該列文字呼叫 askInfoWithDefault
        askInfoWithDefault(thisToDo){
            (sucess: Bool, toDo: String?) in
            // 如果成功有輸入文字的話
            if sucess == true {
                if let okToDo = toDo {
                    self.toDoArray[indexPath.row] = okToDo  // 修改toDoArray的值
                    self.myTableView.reloadData()           // reload
                    // Save to UserDefaults & 同步
                    UserDefaults.standard.set(self.toDoArray, forKey: "toDo")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    // 刪除待辦事項
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoArray.remove(at: indexPath.row)   // 刪除toDoArray的值
            myTableView.reloadData()              // reload
            // Save to UserDefaults & 同步
            UserDefaults.standard.set(self.toDoArray, forKey: "toDo")
            UserDefaults.standard.synchronize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 另一種連結方式
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // load存檔的Array
        if let loadedArray = UserDefaults.standard.stringArray(forKey: "toDo") {
            toDoArray = loadedArray
            myTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

