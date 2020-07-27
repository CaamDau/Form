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
    var deleDa:FormTableViewRx?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        deleDa = FormTableViewRx(forms: vm.forms, tableView: tableView)
        
        vm.makeForm()
    }
}

class FormTableViewRx: NSObject {
    let dataSource = RxTableViewSectionedReloadDataSource<FormRx>(
        configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let row = item
            let cell = tableView.cd.cell(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") ?? UITableViewCell()
            row.bind(cell)
            return cell
            
    })
    let disposeBag = DisposeBag()
    
    init(forms:BehaviorRelay<[FormRx]>, tableView:UITableView) {
        super.init()
        forms
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(FormRx.Item.self)
            .subscribe(onNext: { item in
                item.tapBlock?()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension FormTableViewRx: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].header?.h ?? 0.001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource[section].footer?.h ?? 0.001
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.section].items[indexPath.row].h
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let row = dataSource[section].header else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let row = dataSource[section].header else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
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
            
            forms.accept([FormRx(header:header, footer: footer, items: rows)])
        }
        do{
            let header:CellProtocol = RowCell<Header_Rx>(data: "第二组组头", config: .yellow, frame: CGRect(h:40))
            let footer:CellProtocol = RowCell<Header_Rx>(data: "第二组组尾", config: .gray, frame: CGRect(h:30))
            
            var rows:[CellProtocol] = []
            (0..<5).forEach { i in
                let row = RowCell<Cell_Image>(data: ("title-\(i)", "2020.1.\(i)"), frame: CGRect(h:CGFloat(60 + 10*i)))
                rows += [row]
            }
            
            forms.accept(forms.value + [FormRx(header:header, footer: footer, items: rows)])
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



