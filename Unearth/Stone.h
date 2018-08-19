//
//  Stone.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "HexTile.h"

typedef enum StoneColor : NSUInteger {
    StoneColorRed = 0,
    StoneColorYellow = 1,
    StoneColorBlue = 2,
    StoneColorBlack = 3
} StoneColor;

@interface Stone : HexTile {

    StoneColor color;
    
}

/*
 Method list from [Object Library.txt]
 > Stone : HexTile
 - color             // black, blue, red, yellow

 */

@end
