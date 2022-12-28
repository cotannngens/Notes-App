import UIKit
import SnapKit

class SelectedNoteViewController: UIViewController {
    var note: Note!
    weak var delegate: AllNotesDelegate?
    
    private lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.contentMode = .scaleToFill
        textView.font = UIFont(name: "HelveticaNeue", size: 20.multiplierY)
        textView.delegate = self
        textView.backgroundColor = .systemGroupedBackground
        textView.allowsEditingTextAttributes = true
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addingSubviews()
        setupConst()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteTextView.becomeFirstResponder()
    }

    private func setupUI() {
        view.setNeedsDisplay()
        view.snapshotView(afterScreenUpdates: true)
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.largeTitleDisplayMode = .never
        
        noteTextView.text = note?.text
    }
    
    private func addingSubviews() {
        view.addSubview(noteTextView)
    }
    
    private func setupConst() {
        noteTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.multiplierX)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func doneButtonPressed() {
        noteTextView.endEditing(true)
    }
    
    private func updateNote() {
        note.lastUpdated = Date()
        CoreDataManager.shared.save()
        delegate?.refreshNotes()
    }
    
    private func deleteNote() {
        delegate?.deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }
    
    deinit {
        if note?.title.isEmpty ?? true {
            deleteNote()
        }
    }
}

extension SelectedNoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.text = textView.text
        if note?.title.isEmpty == false {
            updateNote()
        }
        navigationItem.rightBarButtonItem = nil
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )
    }
}

