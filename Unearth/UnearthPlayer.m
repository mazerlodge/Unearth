//
//  UnearthPlayer.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthPlayer.h"

@implementation UnearthPlayer

- (id) initWithPlayerType: (UnearthPlayerType) type dieColor: (DelverDieColor) color playerName: (NSString *) name {
    playerType = type;
    playerName = name;
    dieColor = color;
    
    return self;
    
}

- (DelverDieColor) dieColor {
    return dieColor;
    
}

- (NSString *) playerName {
    return playerName;
    
}
@end
