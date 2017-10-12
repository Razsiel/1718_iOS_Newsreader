//
//  Article.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation

public class Article : Decodable{
    public var id : Int
    public var feed : Int
    public var title : String
    public var summary : String
    public var publishDate : String
    public var image : String
    public var url : String
    public var related : Array<String>
    public var categories : Array<Category>
    public var isLiked : Bool
    
    init() {
        id = 0
        feed = 0
        title = "Title"
        summary = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui."
        publishDate = ""
        image = ""
        url = "www.google.com"
        related = []
        categories = []
        isLiked = false
    }
    
    // for serialisation
    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case feed = "Feed"
        case title = "Title"
        case summary = "Summary"
        case publishDate = "PublishDate"
        case image = "Image"
        case url = "Url"
        case related = "Related"
        case categories = "Categories"
        case isLiked = "IsLiked"
    }
}
