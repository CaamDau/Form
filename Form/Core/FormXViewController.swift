//Created  on 2019/12/19 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 * FormXViewController 包含两类
 * 1、普通MVVM模式
 * 2、MVC模式
 */




import UIKit

//@IBDesignable
/// ViewController 组装基类，里面包含一个 StackView
open class FormXViewController: UIViewController {
    public lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        return v
    }()
    /// 头部安全区约束
    open var safeAreaTop:Bool = true
    /// 尾部安全区约束
    open var safeAreaBottom:Bool = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cd_hex("f", dark: "0")
        makeStackView()
    }
}

extension FormXViewController {
    @objc func makeStackView() {
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        }
        
        if !safeAreaTop {
            
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        }else if #available(iOS 11.0, *) {
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            stackView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor).isActive = true
        }
        
        if !safeAreaBottom {
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }else if #available(iOS 11.0, *) {
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            stackView.topAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor).isActive = true
        }
    }
}




//@IBDesignable
/// TableViewController 组装基类，Form 协议 下的普通 MVVM 模式
/// 继承自FormXViewController，StackView内包含一个 TableView
open class FormXTableViewController: FormXViewController {
    open lazy var tableView: UITableView = {
        return UITableView(frame: CGRect.zero, style: style)
    }()
    open var style:UITableView.Style = .grouped
    /// 数据源遵循 FormProtocol 协议
    open var _forms:[FormXDataSource]?
    /// tableView Delegate DataSource 代理类
    open lazy var _delegateData:FormXTableViewDelegateDataSource? = {
        return FormXTableViewDelegateDataSource(_forms)
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
    }
}

extension FormXTableViewController {
    @objc open func makeTableView() {
        stackView.addArrangedSubview(tableView)
        tableView.delegate = _delegateData
        tableView.dataSource = _delegateData
    }
}


//@IBDesignable
/// CollectionViewController 组装基类，Form 协议 下的普通 MVVM 模式
/// 继承自FormXViewController，StackView内包含一个 CollectionView
open class FormXCollectionViewController: FormXViewController {
    
    open lazy var flowLayout: UICollectionViewLayout = {
        return UICollectionViewFlowLayout()
    }()
    
    open lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    /// 数据源遵循 FormProtocol 协议
    open var _forms:[FormXDataSource]?
    /// CollectionView Delegate DataSource DelegateFlowLayout  代理类
    open lazy var _delegateData:FormXCollectionViewDelegateDataSource? = {
        return FormXCollectionViewDelegateDataSource(_forms)
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionView()
    }
}

extension FormXCollectionViewController {
    @objc open func makeCollectionView() {
        stackView.addArrangedSubview(collectionView)
        collectionView.delegate = _delegateData
        collectionView.dataSource = _delegateData
        _delegateData?.makeReloadData(collectionView)
    }
}






//MARK:--- 如果你依然钟情于MVC模式，那么这个基类将适用 ----------
/// ViewController 组装基类，普通 MVC 模式
/// 内含两个排版 Form 数据源，
/// 已实现基本 TableViewDelegate/DataSource、CollectionViewDelegate/DataSource/DelegateFlowLayout
/// 继承 FormXBaseViewController 的基础上课重写，并可实现剩余协议，获得剩余功能
extension FormXBaseViewController {
    
}
open class FormXBaseViewController: UIViewController {
    /// 排版组装数据源
    open var _forms:[FormXDataSource]?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension FormXBaseViewController: UITableViewDelegate, UITableViewDataSource  {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return _forms?.count ?? 0
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _forms?[section].rows.count ?? 0
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = _forms?[indexPath.section].rows[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.cd.cell(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") ?? UITableViewCell()
        row.bind(cell)
        return cell
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = _forms?[indexPath.section].rows[indexPath.row] else {
            return
        }
        row.tapBlock?()
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = _forms?[indexPath.section].rows[indexPath.row] else {
            return 0
        }
        return row.h
    }
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let h = _forms?[section].header?.h {
            return h
        }
        else if let h = _forms?[section].rows.first?.insets.top, h > 0 {
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
        else if let h = _forms?[section].rows.first?.insets.bottom, h > 0 {
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


extension FormXBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _forms?.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _forms?[section].rows.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return _forms?[indexPath.section].rows[indexPath.row].size ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let row = _forms?[indexPath.section].rows[indexPath.row] else {
            return collectionView.cd.cell(RowCollectionViewCellNone.id, indexPath)
        }
        let cell = collectionView.cd.cell(row.cellId, indexPath)
        row.bind(cell)
        return cell
    }
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let row = _forms?[indexPath.section].rows[indexPath.row] else {
            return
        }
        row.tapBlock?()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let header = _forms?[section].header {
            return header.y
        }else{
            return _forms?[section].rows.first?.y ?? 0
        }
        
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let header = _forms?[section].header  {
            return header.x
        }else{
            return _forms?[section].rows.first?.x ?? 0
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
            return _forms?[section].rows.first?.insets ?? .zero
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
