//
//  UnearthPlayerHexMap.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthPlayerHexMap.h"

@implementation UnearthPlayerHexMap

- (id) init {
    
    UnearthPlayerHexCell *aCell = [[UnearthPlayerHexCell alloc] initWithRow:50 Column:50];
    hexCells = [[NSArray alloc] arrayByAddingObject:aCell];

    return self;
    
}

- (bool) addStone: (Stone *) s touchingHexCell: (UnearthPlayerHexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;
    
    // TODO: Flesh out Hex Map addStone method.
    
    return bRval;
    
}

- (bool) addWonder: (Wonder *) w touchingHexCell: (UnearthPlayerHexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;

    // TODO: Flesh out Hex Map addWonder method.

    return bRval;
    
}

@end
