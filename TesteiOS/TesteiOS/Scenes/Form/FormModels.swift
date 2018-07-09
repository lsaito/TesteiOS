//
//  FormModels.swift
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

enum Form
{
  // MARK: Use cases
  
  enum FetchCells
  {
    struct Request
    {
    }
    struct Response
    {
        var cells: [Cell]
    }
    struct ViewModel
    {
        var cells: [Cell]
    }
  }
    
    enum FormCell {
        struct ViewModel {
            var type: CellType = .field
            var typeField: CellTypeField?
            var topSpacing: Float = 0.0
            var message: String = ""
        }
    }
}
