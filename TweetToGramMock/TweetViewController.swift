//
//  TweetViewController.swift
//  TweetToGramMock
//
//  Created by Val V on 13/04/22.
//

import UIKit
import SwiftSpinner
import ErrorView


class TweetViewController: UIViewController {
    
    private var errorView: ErrorView?

    private let searchBox:UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Eg:https://twitter.com/elonmusk/status/1453954994546229253?s=20",
            attributes: [.foregroundColor:UIColor.lightGray,.font:UIFont.systemFont(ofSize: 16, weight: .thin)]
        )
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = .black
        tf.layer.borderWidth = 0.8
        tf.layer.borderColor = UIColor.black.cgColor
        tf.translatesAutoresizingMaskIntoConstraints = true
        return tf
    }()
    
    private let label:UILabel = {
        let label = UILabel()
        label.text = "Enter Tweet Link"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let getTweet:UIButton = {
        let bt = UIButton()
        bt.setTitle("Get Tweet", for: .normal)
        bt.backgroundColor = .twitterBlue
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(handleLink), for: .touchUpInside)
        bt.translatesAutoresizingMaskIntoConstraints = true
        return bt
    }()
    
    let model = TweetModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ErrorView.font = UIFont.boldSystemFont(ofSize: 30.5)
        ErrorView.textColor = UIColor.black
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        searchBox.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    

    private func setupUI(){
        view.addSubview(searchBox)
        searchBox.frame.origin.x = 20
        searchBox.center.y = view.center.y
        print(view.frame.width)
        searchBox.frame.size.width = view.frame.width - 40
        searchBox.frame.size.height = view.frame.height/12
        
        view.addSubview(label)
        label.frame.size.width = view.frame.width
        label.frame.size.height = 30
        label.frame.origin.x = 20
        label.frame.origin.y = searchBox.frame.origin.y - 30
        
        view.addSubview(getTweet)
        getTweet.frame.origin.x = 40
        getTweet.frame.origin.y = searchBox.frame.origin.y + searchBox.frame.height + 30
        getTweet.frame.size.width =  view.frame.width - 80
        getTweet.frame.size.height = view.frame.height/18
        getTweet.layer.cornerRadius = 8
    }
    
    @objc func handleLink(){
        guard let tweetUrl = searchBox.text,!tweetUrl.isEmpty else {return}
        SwiftSpinner.show("Fetching Tweet")
        model.fetchTweet(url: tweetUrl) { [self] result in
            switch result{
            case .success(let tweet):
                print(tweet)
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                    self.searchBox.resignFirstResponder()
                    let vc = ViewController(tweet: tweet)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let err):
                SwiftSpinner.hide()
                self.errorView = ErrorView(addTo:self, text: "Some Error Occurred!",backgroundColor: .twitterBlue,textColor: .white)
                print(err)
            }
        }
    }
    

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }
    }



}

extension TweetViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBox.resignFirstResponder()
    }
}
