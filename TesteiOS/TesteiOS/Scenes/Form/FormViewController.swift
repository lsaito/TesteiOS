//
//  FormViewController.swift
//  TesteiOS
//
//  Created by lucas.eiji.saito on 22/05/18.
//  Copyright (c) 2018 Accenture. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FormDisplayLogic: class
{
  func displayCells(viewModel: Form.FetchCells.ViewModel)
}

class FormViewController: UIViewController, FormDisplayLogic
{
  var interactor: FormViewControllerOutput?
  var router: (NSObjectProtocol & FormRoutingLogic & FormDataPassing)?
    var tableView: UITableView!
    var cells: [Cell] = []

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = FormInteractor()
    let presenter = FormPresenter()
    let router = FormRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView = UITableView(frame: self.view.frame)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    self.view.addSubview(self.tableView)
    
    fetchCellsOnLoad()
  }
  
  // MARK: Do something
  
  func fetchCellsOnLoad()
  {
    let request = Form.FetchCells.Request()
    interactor?.fetchCells(request: request)
  }
    
    
  func displayCells(viewModel: Form.FetchCells.ViewModel)
  {
    self.cells = viewModel.cells
    tableView.reloadData()
  }
}

// MARK: TableView Delegate
// MARK: TableView DataSource
extension FormViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView: UITableViewCell = UITableViewCell()
        let cell = cells[indexPath.row]
        print("-> ", cell)
        
//        cellView.backgroundColor = UIColor.brown
        
        let metrics = [
            "topMargin": cell.topSpacing!]
        
        switch cell.type! {
        case .field:
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
//            textField.backgroundColor = UIColor.green
            textField.placeholder = cell.message
            
            cellView.addSubview(textField)
            
            let viewsDict = [
                "textfield" : textField
                ] as [String : Any]
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textfield]-|", options: [], metrics: nil, views: viewsDict))
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[textfield]|", options: [], metrics: metrics, views: viewsDict))
        case .text:
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = cell.message
//            label.backgroundColor = UIColor.blue
            
            cellView.addSubview(label)
            
            let viewsDict = [
                "label" : label
                ] as [String : Any]
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: viewsDict))
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[label]|", options: [], metrics: metrics, views: viewsDict))
        case .image:
            let imageView = UIImageView()
            cellView.addSubview(imageView)
        case .checkbox:
            let checkbox = UIButton()
            checkbox.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            label.text = cell.message
//            label.backgroundColor = UIColor.blue
            
            cellView.addSubview(checkbox)
            cellView.addSubview(label)
            
            let viewsDict = [
                "checkbox" : checkbox,
                "label" : label
                ] as [String : Any]
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[checkbox]-[label]-|", options: [.alignAllCenterY], metrics: nil, views: viewsDict))
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[checkbox]|", options: [], metrics: metrics, views: viewsDict))
        case .send:
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(cell.message, for: UIControlState.normal)
            
            cellView.addSubview(button)
            
            let viewsDict = [
                "button" : button
                ] as [String : Any]
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|", options: [], metrics: nil, views: viewsDict))
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[button]|", options: [], metrics: metrics, views: viewsDict))
        default:
            print("~> cell type not found")
        }
        
        return cellView
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
