//
//  HexCell.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "HexCell.h"

@implementation HexCell


- (id) initWithRow: (int) r Column: (int) c {
    
    row = r;
    column = c;
    isWonder = false;
    
    return self;
    
}

@end
