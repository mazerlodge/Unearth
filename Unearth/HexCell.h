//
//  HexCell.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexTile.h"
#import "HexCellPosition.h"

@interface HexCell : NSObject {
	HexCellPosition *pos;
	int columnX;
	int rowY;
    HexTile *hexTile;

}

- (id) initWithRow: (int) r Column: (int) c;

- (void) setTile: (HexTile *) tile;
- (HexTile *) getTile;

- (bool) isWonder;
- (bool) isOccupied;
- (bool) isAtRow: (int) targetRow Column: (int) targetColumn;

- (int) getRowPosition;
- (int) getColumnPosition;
- (HexCellPosition *) getPosition;

- (NSString *) toString;



/*
 Method list from [Object Library.txt]
 > PlayerHexCell
 - row, column          // id or position within overall grid system, for finding neighbors
 - hexTile           // either emty, a wonder, or a stone
 - isWonder          // set to true to aid in casting contents to a wonder object.

 */

@end
