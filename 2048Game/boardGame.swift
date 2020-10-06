//
//  boardGame.swift
//  2048Game
//
//  Created by hyperactive on 22/09/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class boardGame: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var squares = [Int]()
    
    
    let reuseIdentifier = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        addGestures()
        initiateSquaresArray()
        //showBoardAfterChanges()
        //createTools()
        //showNewValueRandomly()
        //createFlowLayout()
        //showNewRandomValue()
    }
    
    func initiateSquaresArray() {

        for _ in 0...15
        {
            squares.append(0)
        }
        
    }
    
    func addGestures() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)

    }
    
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if is2048Achieved() || isWholeBoardOccupied() {
                return
            }
            var isSwipeSucceeded: Bool = false
            
            switch sender.direction {
            case .right:
                if swipeRight() {
                    isSwipeSucceeded = true
                }
            case .left:
                if swipeLeft() {
                    isSwipeSucceeded = true
                }
            case .up:
                if swipeUp() {
                    isSwipeSucceeded = true
                }
            case .down:
                if swipeDown() {
                    isSwipeSucceeded = true
                }
            default:
                break
                
            }
            if isSwipeSucceeded {
                showNewRandomValue()
            }
            
        }
    }
    
    func swipeUp() -> Bool {
        var isSwipeSucceeded: Bool = false
        for _ in 0...2 { // there are 3 options of going up
                for index in 4...15 { // squares before 4 are not allowed to move up
                    if squares[index] != 0 { // square has a value
                        if squares[index - 4] == 0 { // square above is empty
                            squares[index - 4] = squares[index] // square goes up
                            squares[index] = 0
                            isSwipeSucceeded = true
                        }
                        else if squares[index - 4] == squares[index] { // same value
                            squares[index - 4] *= 2
                            squares[index] = 0
                            isSwipeSucceeded = true
                        }
                    
                }
            }
        }
        showBoardAfterChanges()
        return isSwipeSucceeded
    }
    
    func swipeDown() -> Bool {
        var isSwipeSucceeded: Bool = false
        for _ in 0...2 { // there are 3 options of going down
            for index in 0...11 { // squares before 4 are not allowed to move down
                    if squares[index] != 0 { // square has a value
                        if squares[index + 4] == 0 { // square under is empty
                            squares[index + 4] = squares[index] // square goes down
                            squares[index] = 0
                            isSwipeSucceeded = true
                        }
                        else if squares[index + 4] == squares[index] { // same value
                            squares[index + 4] *= 2
                            squares[index] = 0
                            isSwipeSucceeded = true
                        }
                    
                }
            }
        }
        showBoardAfterChanges()
        return isSwipeSucceeded
    }
    
    func swipeRight() -> Bool {
        var isSwipeSucceeded: Bool = false
        for _ in 0...2 { // there are 3 options of going right
            for index in 0...15 {
                if index == 3 || index == 7 || index == 11 || index == 15 // cant move right
                {
                    continue
                }
                if squares[index] != 0 { // square has a value
                    if squares[index + 1] == 0 { // square right is empty
                        squares[index + 1] = squares[index] // square goes right
                        squares[index] = 0
                        isSwipeSucceeded = true
                    }
                    else if squares[index + 1] == squares[index] { // same value
                        squares[index + 1] *= 2
                        squares[index] = 0
                        isSwipeSucceeded = true
                    }
                }
            }
        }
        showBoardAfterChanges()
        //UIView.transition(with: collectionView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.collectionView.reloadData()}, completion: nil)
        //self.collectionView.reloadData()
        return isSwipeSucceeded
    }
    
    func swipeLeft() -> Bool {
        var isSwipeSucceeded = true
        for _ in 0...2 { // there are 3 options of going left
            for index in 0...15 {
                if index == 0 || index == 4 || index == 8 || index == 12 // cant move left
                {
                    continue
                }

                if squares[index] != 0 { // square has a value
                    if squares[index - 1] == 0 { // square left is empty
                        squares[index - 1] = squares[index] // square goes left
                        squares[index] = 0
                        isSwipeSucceeded = true
                    }
                    else if squares[index - 1] == squares[index] { // same value
                        squares[index - 1] *= 2
                        squares[index] = 0
                        isSwipeSucceeded = true
                    }
                }
            }
        }
        showBoardAfterChanges()
        return isSwipeSucceeded
    }
    
    
    
    
    func showBoardAfterChanges() {
        
        for section in 0...3 {
            for item in 0...3 {
                let indexPath = NSIndexPath(item: item, section: section)
                let cell = collectionView.cellForItem(at: indexPath as IndexPath)
                
                
                let cellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell?.bounds.size.width ?? 0, height: 40))
                cellLabel.textColor = UIColor.black
                let locationInArray = section * 4 + item
                if let viewWithTag = cell?.viewWithTag(100) // first remove last value of square
                {
                    viewWithTag.removeFromSuperview() // remove last value of moving squares
                }
                if squares[locationInArray] != 0 { // no need to present 0 value on squares
                    cellLabel.text = "\(squares[locationInArray])"
                    print("\(squares[locationInArray])")
                    cellLabel.textAlignment = .center
                    cellLabel.tag = 100
                    cellLabel.font = cellLabel.font.withSize(40)
                    cell?.contentView.addSubview(cellLabel)
                    paint(cell: cell! as! CollectionViewCell, locationInArray: locationInArray)
                    UIView.transition(with: cell!.contentView, duration: 0.25, options: .transitionFlipFromLeft, animations: {}, completion: nil)

                }
            }
        }
    }
    
    func paint(cell: CollectionViewCell, locationInArray: Int) {
        switch squares[locationInArray] {
        case 2:
            cell.backgroundColor = .lightGray
        case 4:
            cell.backgroundColor = .brown
        case 8:
            cell.backgroundColor = .orange
        case 16:
            cell.backgroundColor = .red
        case 32:
            cell.backgroundColor = .purple
        case 64:
            cell.backgroundColor = .green
        default:
            cell.backgroundColor = .darkGray
        }
        
    }
    
    func is2048Achieved() -> Bool {
        for index in 0...15 {
            if squares[index] == 2048 {
                print("you have won")
                let alert = UIAlertController(title: "Good!", message: "2048 is done", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "you have won", style: .default, handler: { action in}))
                self.present(alert, animated: true, completion: nil)
                return true
            }
        }
        return false
    }
    
    func isWholeBoardOccupied() -> Bool {
        var sumOfSquaresOccupied = 0
        for index in 0...15 {
            if squares[index] != 0 {
                sumOfSquaresOccupied += 1
            }
        }
        if sumOfSquaresOccupied == 16 {
            print("the whole board is occupied")
            let alert = UIAlertController(title: "Game Over!", message: "board is full", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "you have lost", style: .default, handler: { action in}))
            self.present(alert, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.lightGray
        //animateSwipe(cell: cell)

        return cell

    }
    
    func putSquaresIntoArray() {
        squares.removeAll()
        for section in 0..<4
        {
            for item in 0..<4
            {
                let indexPath = NSIndexPath(item: item, section: section)
                let cell: CollectionViewCell = collectionView.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
                squares.append(cell.value)
                
                //squares[section][item] = cell.value
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //showNewValueRandomly()
        showNewRandomValue()
        print("selected cell #\(indexPath.item)!")
    }
    
    
    
    func assignValueIntoCell(_ cell: UICollectionViewCell) -> UILabel {
        let cellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
        cellLabel.textColor = UIColor.black
        cellLabel.text = "2"
        cellLabel.textAlignment = .center
        return cellLabel
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height / 4)
    }
    

    
    

    

    
    func createFlowLayout() {
            //flow layout
            let cellWidth: CGFloat = (self.view.frame.width - 20.0) / 4
            let cellHeight: CGFloat = (self.view.frame.height - 50.0) / 4
            let collectionViewLayout: UICollectionViewFlowLayout = (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout)
            
            collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        
    }
    
    func showNewRandomValue() {
        var randSection = Int.random(in: 0..<4)
        var randItem = Int.random(in: 0..<4)
        var locationOfSquareInArray = randSection * 4 + randItem
        while squares[locationOfSquareInArray] != 0 {
            randSection = Int.random(in: 0..<4)
            randItem = Int.random(in: 0..<4)
            locationOfSquareInArray = randSection * 4 + randItem
        }
        squares[locationOfSquareInArray] = 2
        showBoardAfterChanges()
        
        //var indexPath = NSIndexPath(item: randItem, section: randSection)
        //var cell: CollectionViewCell = collectionView.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
        //indexPath = NSIndexPath(item: randItem, section: randSection)
        //cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
        
        
        //let cellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
        //cellLabel.textColor = UIColor.black
        //cellLabel.text = "2"
        //cellLabel.textAlignment = .center
        //cellLabel.tag = 100
        //cell.contentView.addSubview(cellLabel)
        //print("item: \(randItem), section: \(randSection)")
        
    }
    

    
    func showNewValueRandomly() {
 
        var randSection = Int.random(in: 0..<4)
        var randItem = Int.random(in: 0..<4)
        
        var indexPath = NSIndexPath(item: randItem, section: randSection)
        var cell: CollectionViewCell = collectionView.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
        while (cell.value != 0) // this cell is not empty
        {
            randSection = Int.random(in: 0..<4)
            randItem = Int.random(in: 0..<4)
            
            indexPath = NSIndexPath(item: randItem, section: randSection)
            cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
        }
        let cellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
        cellLabel.textColor = UIColor.black
        cellLabel.text = "2"
        cellLabel.textAlignment = .center
        cellLabel.tag = 100
        cell.contentView.addSubview(cellLabel)
        cell.value = 2
        print("item: \(randItem), section: \(randSection)")
    }
    
    func animateSwipe(cell:CollectionViewCell) {
        UIView.transition(with: cell.contentView, duration: 0.25, options: .transitionFlipFromLeft, animations: {}, completion: nil)
    }
    
}

class CollectionViewCell: UICollectionViewCell {
    var value: Int = 0
    var isEmpty = true
    
    
}




