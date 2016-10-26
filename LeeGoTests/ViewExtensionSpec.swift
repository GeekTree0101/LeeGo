//
//  ViewExtensionSpec.swift
//  LeeGo
//
//  Created by Victor WANG on 20/02/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

import Quick
import Nimble
@testable import LeeGo

class ViewExtensionSpec: QuickSpec {
    override func spec() {
        describe("View extensions") {
            it("should configure an empty brick correctly.") {
                // Given
                let view = UIView()
                expect(view.currentBrick).to(beNil())

                // When
                view.lg_configureAs(Brick(name: "article"))

                // Then
                expect(view.currentBrick) != nil
                expect(view.lg_brickName) == "article"
                expect(view.isRoot) == true
            }

            it("should configure a brick correctly.") {
                // Given
                let view = UIView()

                // When
                view.lg_configureAs(TestData.header1)

                // Then
                expect(view.currentBrick) != nil
                XCTAssertTrue(type(of: view) == UIView.self)
                expect(view.lg_brickName) == "header"
                expect(view.isRoot) == true
                expect(view.currentBrick) == TestData.header1
                expect(view.currentBrick!.layout!.formats) == ["H:|-left-[title]-(>=right)-|", "H:|-left-[avatar]-(>=right)-|", "V:|-top-[title]-spaceV-[avatar]-bottom-|"]
                expect(view.backgroundColor) == UIColor.red
                expect(view.subviews.count) == 2
                expect((view.subviews[0] as! UILabel).currentBrick) == TestData.title1
                expect((view.subviews[0] as! UILabel).lg_brickName) == "title"
                expect((view.subviews[0] as! UILabel).font) == UIFont(name: "Helvetica", size: 18)
                expect((view.subviews[1] as! UIImageView).currentBrick) == TestData.avatar1
                expect((view.subviews[1] as! UIImageView).lg_brickName) == "avatar"
            }

            it("should re-configure a brick correctly with .WhenBrickChanged strategy -> brick changed") {
                // Given
                let cell = UITableViewCell()
                cell.lg_configureAs(TestData.header1)
                cell.lg_configureAs(TestData.header2, updatingStrategy: .always)

                // When
                cell.lg_configureAs(TestData.header3)

                // Then
                expect(cell.contentView.currentBrick) != nil
                expect(cell.contentView.lg_brickName) == "header3"
                expect(cell.contentView.isRoot) == true
                expect(cell.contentView.currentBrick) == TestData.header3
                expect(cell.contentView.currentBrick!.layout!.formats) == ["H:|[title3]|", "V:|[view]|"]
                expect(cell.contentView.subviews.count) == 2
                expect((cell.contentView.subviews[1] as! UILabel).currentBrick) == TestData.title3
                expect((cell.contentView.subviews[1] as! UILabel).lg_brickName) == "title3"
                expect((cell.contentView.subviews[1] as! UILabel).font) == UIFont(name: "Arial", size: 14)
                expect((cell.contentView.subviews[0] as UIView).currentBrick) == TestData.view
                expect((cell.contentView.subviews[0] as UIView).lg_brickName) == "view"
            }

            it("should re-configure a brick correctly with .WhenBrickChanged strategy -> brick did not change") {

                // Given
                let view = UIView()
                view.lg_configureAs(TestData.header1)
                view.lg_configureAs(TestData.header2, updatingStrategy: .always)
                view.lg_configureAs(TestData.header1)

                // When
                let emptyHeader = BrickBuilder.header.build()
                view.lg_configureAs(emptyHeader)

                // Then
                expect(view.currentBrick) != nil
                XCTAssertTrue(type(of: view) == UIView.self)
                expect(view.lg_brickName) == "header"
                expect(view.isRoot) == true
                expect(view.currentBrick) == emptyHeader
                expect(view.backgroundColor) == UIColor.red
                expect(view.subviews.count) == 2
                expect((view.subviews[0] as! UILabel).currentBrick) == TestData.title1
                expect((view.subviews[0] as! UILabel).lg_brickName) == "title"
                expect((view.subviews[0] as! UILabel).font) == UIFont(name: "Avenir", size: 12)
                expect((view.subviews[1] as! UIImageView).currentBrick) == TestData.avatar1
                expect((view.subviews[1] as! UIImageView).lg_brickName) == "avatar"
            }

            it("should re-configure a brick correctly with .Always strategy.") {
                // Given
                let cell = UICollectionViewCell()
                cell.lg_configureAs(TestData.header1)

                // When
                cell.lg_configureAs(TestData.header2, updatingStrategy: .always)

                // Then
                expect(cell.contentView.currentBrick) != nil
                expect(cell.contentView.currentBrick) == TestData.header2
                expect(cell.contentView.lg_brickName) == "header2"
                expect(cell.contentView.currentBrick!.layout!.formats) == ["H:|-left-[title]-spaceH-[avatar]-spaceH-[view]-(>=right)-|", "V:|-top-[title]-(>=bottom)-|", "V:|-top-[avatar]-(>=bottom)-|", "V:|-top-[view]-(>=bottom)-|"]
                expect(cell.contentView.backgroundColor).to(beNil())
                expect(cell.contentView.subviews.count) == 3
                expect((cell.contentView.subviews[0] as! UILabel).currentBrick) == TestData.title2
                expect((cell.contentView.subviews[0] as! UILabel).lg_brickName) == "title"
                expect((cell.contentView.subviews[0] as! UILabel).font) == UIFont(name: "Avenir", size: 12)
                expect((cell.contentView.subviews[1] as! UIImageView).currentBrick) == TestData.avatar2
                expect((cell.contentView.subviews[1] as! UIImageView).lg_brickName) == "avatar"
                expect((cell.contentView.subviews[1] as! UIImageView).backgroundColor) == UIColor.green
                expect((cell.contentView.subviews[2] as UIView).currentBrick) == TestData.view
                expect((cell.contentView.subviews[2] as UIView).lg_brickName) == "view"
            }

            it("cell should have dynamic fitting height correctly") {
                // Given
                let cell = UICollectionViewCell()
                cell.lg_configureAs(TestData.header1)

                // When
                let attributes = cell.lg_fittingHeightLayoutAttributes(UICollectionViewLayoutAttributes())

                // Then
                expect(attributes.frame.height) == 71
            }

            it("cell should have dynamic fitting height correctly") {
                // Given
                let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
                cell.lg_configureAs(TestData.header2)

                // When
                let attributes = cell.preferredLayoutAttributesFitting(UICollectionViewLayoutAttributes())

                // Then
                expect(attributes.frame.height) == 130
            }

            it("should find view with outlet key correctly.") {
                // Given
                let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
                cell.lg_configureAs(BrickBuilder.detailsView.brick())

                // When
                let view = cell.lg_viewForOutletKey("favoriteButton")

                // Then
                expect(view).notTo(beNil())
                XCTAssertTrue(type(of: view!) == UIButton.self)
                expect(view?.backgroundColor) == UIColor.green
            }
        }
    }
}

