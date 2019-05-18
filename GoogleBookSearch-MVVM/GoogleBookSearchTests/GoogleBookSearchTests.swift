//
//  GoogleBookSearchTests.swift
//  GoogleBookSearchTests
//
//  Created by Admin on 5/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import XCTest
@testable import GoogleBookSearch

class GoogleBookSearchTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let VC = SearchViewController()
        let books = VC.books
        XCTAssertTrue(books.isEmpty)
    }
    
    func testAsyncGetBookCall() {
        let promise = expectation(description: "waiting for some books..")
        var bookName = "Unknown"
        bookService.getBooks(bookName: "ArtOfWar"){ (books) in
            bookName = books[0].bookName
            print(bookName)
            promise.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue("The Art of War"==bookName)
    }
    
    func testGetJsonPerformance() {
        self.measure {
            bookService.getJson(url: "https://www.googleapis.com/books/v1/volumes?q=ArtOfWar"){ (bookJson) in}
        }
    }
}
