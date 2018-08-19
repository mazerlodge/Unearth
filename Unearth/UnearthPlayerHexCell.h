//
//  UnearthPlayerHexCell.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexTile.h"

@interface UnearthPlayerHexCell : NSObject {
    int position;
    HexTile *hexTile;
    bool isWonder;
}

/*
 Method list from [Object Library.txt]
 > PlayerHexCell
 - position          // id or position within overall grid system, for finding neighbors
 - hexTile           // either emty, a wonder, or a stone
 - isWonder          // set to true to aid in casting contents to a wonder object.

 */

@end