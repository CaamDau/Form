//Created  on 2020/6/17 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import CaamDauForm



class RxViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var vm = VM_RxViewController()
    let disposeBag = DisposeBag()
    var proxy:FormRxTableViewDelegateDataSource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proxy = FormRxTableViewDelegateDataSource(forms: vm.forms, tableView: tableView)
        
        vm.makeForm()
    }
}




class VM_RxViewController {
    var forms = BehaviorRelay<[FormRx]>(value: (0..<Section.end.rawValue).map{ _ in FormRx(items: []) })
    
    enum Section:Int {
        case one = 0
        case two
        case end
    }
    
}

extension VM_RxViewController {
    func makeForm() {
        
        do{
            let header:CellProtocol = RowCell<Header_Rx>(data: "第一组头", config: .red, frame: CGRect(h:40))
            let footer:CellProtocol = RowCell<Header_Rx>(data: "第一组组尾", config: .gray, frame: CGRect(h:30))
            
            var rows:[CellProtocol] = []
            (0..<5).forEach { i in
               let data = RowTableViewCellBase.Model(title: "title-\(i)")
                let row = RowCell<RowTableViewCellBase>(data: data, frame: CGRect(h:45)) {
                    print_cd("点击了-》title-\(i)")
                }
                rows += [row]
            }
            
            //self.forms.value[1] = rows
            
            forms.accept([FormRx(items: rows, header:header, footer: footer)])
        }
        do{
            let header:CellProtocol = RowCell<Header_Rx>(data: "第二组组头", config: .yellow, frame: CGRect(h:40))
            let footer:CellProtocol = RowCell<Header_Rx>(data: "第二组组尾", config: .gray, frame: CGRect(h:30))
            
            var rows:[CellProtocol] = []
            (0..<5).forEach { i in
                let row = RowCell<Cell_Image>(data: ("title-\(i)", "2020.1.\(i)"), frame: CGRect(h:CGFloat(60 + 10*i)))
                rows += [row]
            }
            
            forms.accept(forms.value + [FormRx(items: rows, header:header, footer: footer)])
        }
        append()
        
    }
    
    
    func append() {
        Time.after(3) {
            var rows:[CellProtocol] = []
            (0..<5).forEach { i in
                let row = RowCell<Cell_Image>(data: ("title-\(i)", "2020.1.\(i)"), frame: CGRect(h:CGFloat(60 + 10*i)))
                rows += [row]
            }
            
            self.forms.accept([self.forms.value[0]] + [self.forms.value[1].append(rows: rows)])
        }
    }
}



