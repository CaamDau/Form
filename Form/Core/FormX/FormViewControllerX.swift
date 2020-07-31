//Created  on 2019/12/19 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 *
 */




import UIKit



//@IBDesignable
/// TableViewController 组装基类，Form 协议 下的普通 MVVM 模式
/// 继承自FormViewController，StackView内包含一个 TableView
open class FormTableViewControllerX: FormViewController {
    open lazy var tableView: UITableView = {
        return UITableView(frame: CGRect.zero, style: style)
    }()
    open var style:UITableView.Style = .grouped
    /// 数据源遵循 FormProtocol 协议
    open var _forms:[FormDataSourceX]?
    /// tableView Delegate DataSource 代理类
    open lazy var _proxy:FormTableViewDelegateDataSourceX? = {
        return FormTableViewDelegateDataSourceX(_forms)
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
    }
}

extension FormTableViewControllerX {
    @objc open func makeTableView() {
        stackView.addArrangedSubview(tableView)
        _proxy?.makeDelegateDataSource(tableView)
    }
}


//@IBDesignable
/// CollectionViewController 组装基类，Form 协议 下的普通 MVVM 模式
/// 继承自FormViewController，StackView内包含一个 CollectionView
open class FormCollectionViewControllerX: FormViewController {
    
    open lazy var flowLayout: UICollectionViewLayout = {
        return UICollectionViewFlowLayout()
    }()
    
    open lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    /// 数据源遵循 FormProtocol 协议
    open var _forms:[FormDataSourceX]?
    /// CollectionView Delegate DataSource DelegateFlowLayout  代理类
    open lazy var _proxy:FormCollectionViewDelegateDataSourceX? = {
        return FormCollectionViewDelegateDataSourceX(_forms)
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionView()
    }
}

extension FormCollectionViewControllerX {
    @objc open func makeCollectionView() {
        stackView.addArrangedSubview(collectionView)
        _proxy?.makeDelegateDataSource(collectionView)
    }
}













//MARK:--- 如果你依然钟情于MVC模式，那么这个基类将适用 ----------
/// ViewController 组装基类，普通 MVC 模式
/// 内含两个排版 Form 数据源，
/// 已实现基本 TableViewDelegate/DataSource、CollectionViewDelegate/DataSource/DelegateFlowLayout
/// 继承 FormXBaseViewController 的基础上课重写，并可实现剩余协议，获得剩余功能
extension FormBaseViewControllerX {
    
}
open class FormBaseViewControllerX: UIViewController {
    /// 排版组装数据源
    open var _forms:[FormDataSourceX]?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension FormBaseViewControllerX: UITableViewDelegate, UITableViewDataSource  {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return _forms?.count ?? 0
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _forms?[section].items.count ?? 0
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = _forms?[indexPath.section].items[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.cd.cell(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") ?? UITableViewCell()
        row.bind(cell)
        return cell
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = _forms?[indexPath.section].items[indexPath.row] else {
            return
        }
        row.tapBlock?()
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = _forms?[indexPath.section].items[indexPath.row] else {
            return 0
        }
        return row.h
    }
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let h = _forms?[section].header?.h {
            return h
        }
        else if let h = _forms?[section].items.first?.insets.top, h > 0 {
            return h
        }
        else {
            return CD.sectionMinH
        }
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let h = _forms?[section].footer?.h {
            return h
        }
        else if let h = _forms?[section].items.first?.insets.bottom, h > 0 {
            return h
        }
        else {
            return CD.sectionMinH
        }
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let row = _forms?[section].header else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let row = _forms?[section].footer else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
}


extension FormBaseViewControllerX: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _forms?.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _forms?[section].items.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return _forms?[indexPath.section].items[indexPath.row].size ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let row = _forms?[indexPath.section].items[indexPath.row] else {
            return collectionView.cd.cell(RowCollectionViewCellNone.id, indexPath)
        }
        let cell = collectionView.cd.cell(row.cellId, indexPath)
        row.bind(cell)
        return cell
    }
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let row = _forms?[indexPath.section].items[indexPath.row] else {
            return
        }
        row.tapBlock?()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let header = _forms?[section].header {
            return header.y
        }else{
            return _forms?[section].items.first?.y ?? 0
        }
        
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let header = _forms?[section].header  {
            return header.x
        }else{
            return _forms?[section].items.first?.x ?? 0
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let header = _forms?[section].header {
            return header.insets
        }
        else if let footer = _forms?[section].footer {
            return footer.insets
        }
        else{
            return _forms?[section].items.first?.insets ?? .zero
        }
    }
    
    
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return _forms?[section].header?.size ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return _forms?[section].footer?.size ?? .zero
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case CaamDau<UICollectionView>.Kind.tHeader.stringValue:
            guard let row = _forms?[indexPath.section].header else {
                return collectionView.cd.view(RowCollectionReusableViewNone.id, kind, indexPath)
            }
            let v = collectionView.cd.view(row.cellId, kind, indexPath)
            row.bind(v)
            return v
        default:
            guard let row = _forms?[indexPath.section].footer else {
                return collectionView.cd.view(RowCollectionReusableViewNone.id, kind, indexPath)
            }
            let v = collectionView.cd.view(row.cellId, kind, indexPath)
            row.bind(v)
            return v
        }
    }
}
