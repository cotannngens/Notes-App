import UIKit
import SnapKit

protocol AllNotesDelegate: AnyObject {
    func refreshNotes()
    func deleteNote(with id: UUID)
}

class AllNotesViewController: UIViewController {
    let defaults = UserDefaults.standard
    private var allNotes = [Note]()
    
    private lazy var allNotesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            NotesTableViewCell.self,
            forCellReuseIdentifier: NotesTableViewCell.cellReuseIdentifier
        )
        tableView.rowHeight = 60.multiplierY
        
        return tableView
    }()
    
    override func loadView() {
        view = allNotesTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        isFirstLaunch()
        fetchNotesFromStorage()
    }
    
    private func isFirstLaunch() {
        if defaults.bool(forKey: "First launch") == true {
            defaults.set(true, forKey: "First launch")
        } else {
            allNotes = [CoreDataManager.shared.createFirstLaunchNote()]
            defaults.set(true, forKey: "First launch")
        }
    }

    private func setupUI() {
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .clear
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(newNoteButtonPressed)
        )
    }
    
    @objc private func newNoteButtonPressed() {
        goToEditNote(createNote())
    }
    
    private func indexForNote(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }
   
    private func createNote() -> Note {
        let note = CoreDataManager.shared.createNote()
        
        allNotes.insert(note, at: 0)
        allNotesTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        return note
    }
    
    private func goToEditNote(_ note: Note) {
        let viewController = SelectedNoteViewController()
        viewController.note = note
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fetchNotesFromStorage() {
        allNotes = CoreDataManager.shared.fetchNotes()
    }
    
    private func deleteNoteFromStorage(_ note: Note) {
        deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }
}

extension AllNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.cellReuseIdentifier, for: indexPath) as! NotesTableViewCell
        cell.setupCellContent(note: allNotes[indexPath.row])
        
        return cell
    }
}

extension AllNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditNote(allNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteFromStorage(allNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension AllNotesViewController: AllNotesDelegate {
    func refreshNotes() {
        allNotes = allNotes.sorted { $0.lastUpdated > $1.lastUpdated }
        allNotesTableView.reloadData()
    }
    
    func deleteNote(with id: UUID) {
        let indexPath = indexForNote(id: id, in: allNotes)
        allNotes.remove(at: indexForNote(id: id, in: allNotes).row)
        allNotesTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

