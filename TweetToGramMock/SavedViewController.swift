//
//  SavedViewController.swift
//  TweetToGramMock
//
//  Created by Val V on 05/04/22.
//

import UIKit

class SavedViewController: ViewController {
    
    var newBoard:Board?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        printExistingTemplates()
    }
    
    
    
    func printExistingTemplates(){
        if let t = UserDefaults.standard.value(forKey: "templates") as? [String] {
            print(t)
            if let data = UserDefaults.standard.value(forKey: t[0]) as? Data {
                if let yourViewFromData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Board {
                    newBoard = yourViewFromData
                    setupUI()
                }
                else{
                    print("NOT possible")
                }
            }

        }
    }
    
    func setupUI(){
        guard let newboard =  newBoard else {return}
        board = newboard
        print("FINSIHED")
        for s in board.subviews{
            board.itemsOnBoard.append(s)
            print(s)
        }
        board.addGesturesToItems()
        board.removeFromSuperview()
        view.addSubview(board)
        board.delegate = self
        board.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        board.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        board.center(inView: view)

    }
    

}



    

