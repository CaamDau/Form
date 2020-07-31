//Created  on 2020/7/31 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import UIKit

class CollectionReusableViewHeader: UICollectionReusableView {

    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lab_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

extension CollectionReusableViewHeader: RowCellUpdateProtocol {
    typealias ConfigModel = UIColor
    
    typealias DataSource = String
    
    func row_update(config data: ConfigModel) {
        view_bg.cd.background(data)
    }
    
    func row_update(dataSource data: DataSource) {
        lab_title.cd.text(data)
    }
}
