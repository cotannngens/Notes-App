import UIKit
import SnapKit

final class NotesTableViewCell: UITableViewCell {
    static let cellReuseIdentifier = "NotesTableViewCell"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18.multiplierY)
        label.contentMode = .left
        
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15.multiplierY)
        label.contentMode = .left
        label.textColor = .darkGray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addingSubviews()
        setupConst()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addingSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConst() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15.multiplierX)
            make.top.equalToSuperview().inset(10.multiplierY)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15.multiplierX)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    public func setupCellContent(note: Note) {
        titleLabel.text = note.title
        descriptionLabel.text = note.descriptionOfNote
    }
}
