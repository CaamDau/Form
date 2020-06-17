//Created  on 2019/3/12 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */



import Foundation
import UIKit
import CaamDauForm


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var vm = VM_ViewController()
    var dea:FormTableViewDelegateDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cd.background(.red).estimatedAll()
        
        dea = FormTableViewDelegateDataSource(vm)
        tableView.cd.delegate(dea).dataSource(dea)
        dea?.makeReloadData(tableView)
        
        vm.makeForm()
    }
}


class VM_ViewController {
    var forms: [[CellProtocol]] = []
    var reloadData: (() -> Void)?
}

extension VM_ViewController {
    func makeForm() {
        var ff:[CellProtocol] = []
        (0..<100).forEach {
           let data = RowTableViewCellBase.Model(title: "title-\($0)")
            let row = RowCell<RowTableViewCellBase>(data: data, frame: CGRect(h:50))
            ff += [row]
        }
        
        forms = [ff]
        reloadData?()
    }
}


extension VM_ViewController: FormProtocol {
    var _forms: [[CellProtocol]] {
        return forms
    }
    var _reloadData: (() -> Void)? {
        set{
            reloadData = newValue
        }
        get{
            return reloadData
        }
    }
}


