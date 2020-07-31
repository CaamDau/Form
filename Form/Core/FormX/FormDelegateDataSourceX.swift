//Created  on 2020/7/14 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import Foundation

open class FormDelegateDataSourceX: NSObject {
    open var form: [FormDataSourceX]?
    private override init(){}
    public init(_ form:[FormDataSourceX]?) {
        self.form = form
    }
}


//MARK:--- TableView DelegateDataSource ----------
open class FormTableViewDelegateDataSourceX: FormDelegateDataSourceX {
    @objc open func makeDelegateDataSource(_ tableView:UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FormTableViewDelegateDataSourceX: UITableViewDelegate, UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return form?.count ?? 0
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form?[section].items.count ?? 0
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = form?[indexPath.section].items[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.cd.cell(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") ?? UITableViewCell()
        row.bind(cell)
        return cell
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = form?[indexPath.section].items[indexPath.row] else {
            return
        }
        row.tapBlock?()
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = form?[indexPath.section].items[indexPath.row] else {
            return 0
        }
        return row.h
    }
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let h = form?[section].header?.h {
            return h
        }
        else if let h = form?[section].items.first?.insets.top, h > 0 {
            return h
        }
        else {
            return CD.sectionMinH
        }
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let h = form?[section].footer?.h {
            return h
        }
        else if let h = form?[section].items.first?.insets.bottom, h > 0 {
            return h
        }
        else {
            return CD.sectionMinH
        }
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let row = form?[section].header else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let row = form?[section].footer else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
}


//MARK:--- CollectionView DelegateDataSource ----------
open class FormCollectionViewDelegateDataSourceX: FormDelegateDataSourceX {
    
}
extension FormCollectionViewDelegateDataSourceX {
    @objc open func makeDelegateDataSource(_ collectionView:UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension FormCollectionViewDelegateDataSourceX: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return form?.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return form?[section].items.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return form?[indexPath.section].items[indexPath.row].size ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let row = form?[indexPath.section].items[indexPath.row] else {
            return collectionView.cd.cell(RowCollectionViewCellNone.id, indexPath)
        }
        let cell = collectionView.cd.cell(row.cellId, indexPath)
        row.bind(cell)
        return cell
    }
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let row = form?[indexPath.section].items[indexPath.row] else {
            return
        }
        row.tapBlock?()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let header = form?[section].header {
            return header.y
        }else{
            return form?[section].items.first?.y ?? 0
        }
        
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let header = form?[section].header  {
            return header.x
        }else{
            return form?[section].items.first?.x ?? 0
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let header = form?[section].header {
            return header.insets
        }
        else if let footer = form?[section].footer {
            return footer.insets
        }
        else{
            return form?[section].items.first?.insets ?? .zero
        }
    }
    
    
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return form?[section].header?.size ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return form?[section].footer?.size ?? .zero
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case CaamDau<UICollectionView>.Kind.tHeader.stringValue:
            guard let row = form?[indexPath.section].header else {
                return collectionView.cd.view(RowCollectionReusableViewNone.id, kind, indexPath)
            }
            let v = collectionView.cd.view(row.cellId, kind, indexPath)
            row.bind(v)
            return v
        default:
            guard let row = form?[indexPath.section].footer else {
                return collectionView.cd.view(RowCollectionReusableViewNone.id, kind, indexPath)
            }
            let v = collectionView.cd.view(row.cellId, kind, indexPath)
            row.bind(v)
            return v
        }
    }
}



