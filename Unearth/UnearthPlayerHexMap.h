//
//  UnearthPlayerHexMap.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnearthPlayerHexCell.h"
#import "Stone.h"
#import "Wonder.h"

typedef enum HexDirection : NSUInteger {
    HexDirectionN = 0,
    HexDirectionNE = 1,
    HexDirectionE = 2,
    HexDirectionSE = 3,
    HexDirectionS = 4,
    HexDirectionSW = 5,
    HexDirectionW = 6,
    HexDirectionNW = 7
} HexDirection;

@interface UnearthPlayerHexMap : NSObject {
    NSArray *hexCells;
    
}

- (id) init;

/*
 Method list from [Object Library.txt]
 > PlayerHexMap
 - hexCells            // grid of hex cells used to hold acquired hex tiles (stones and wonders).

 */

@end
