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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = RxTableViewSectionedReloadDataSource<FormItem>(
            configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
                let row = item
                let cell = tableView.cd.cell(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") ?? UITableViewCell()
                row.bind(cell)
                return cell
                
        })
        vm.forms
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(FormItem.Item.self)
            .subscribe(onNext: { item in
                item.tapBlock?()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        vm.makeForm()
    }
}

extension RxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return vm.forms.value[section].header?.h ?? 0.001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return vm.forms.value[section].footer?.h ?? 0.001
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return vm.forms.value[indexPath.section].items[indexPath.row].h
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let row = vm.forms.value[section].header else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let row = vm.forms.value[section].footer else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
}

struct FormItem {
    var header: Item?
    var footer: Item?
    var items: [Item]
}
extension FormItem: SectionModelType {
    typealias Item = CellProtocol
    init(original: FormItem, items: [Item], header: Item? = nil, footer: Item? = nil) {
        self.init(original: original, items: items)
        self.header = header
        self.footer = footer
    }
    
    init(original: FormItem, items: [Item]) {
        self = original
        self.items = items
    }
}

class VM_RxViewController {
    var forms = BehaviorRelay<[FormItem]>(value: [])
}
extension VM_RxViewController {
    func makeForm() {
        do{
            let header:CellProtocol = RowCell<Header_Rx>(data: "第一组头", config: .red, frame: CGRect(h:40))
            let footer:CellProtocol = RowCell<Header_Rx>(data: "第一组组尾", config: .gray, frame: CGRect(h:30))
            
            
            var ff:[CellProtocol] = []
            (0..<5).forEach { i in
               let data = RowTableViewCellBase.Model(title: "title-\(i)")
                let row = RowCell<RowTableViewCellBase>(data: data, frame: CGRect(h:45)) {
                    print_cd("点击了-》title-\(i)")
                }
                ff += [row]
            }
            forms.accept(forms.value + [FormItem(header:header, footer: footer, items: ff)])
        }
        do{
            let header:CellProtocol = RowCell<Header_Rx>(data: "第二组组头", config: .yellow, frame: CGRect(h:40))
            let footer:CellProtocol = RowCell<Header_Rx>(data: "第二组组尾", config: .gray, frame: CGRect(h:30))
            
            var ff:[CellProtocol] = []
            (0..<10).forEach { i in
                let row = RowCell<Cell_Image>(data: ("title-\(i)", "2020.1.\(i)"), frame: CGRect(h:CGFloat(60 + 10*i)))
                ff += [row]
            }
            forms.accept(forms.value + [FormItem(header:header, footer: footer, items: ff)])
        }
    }
}



