//
//  RuinCard.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum RuinCardColor : NSUInteger {
    RuinCardColorPeach = 0,
    RuinCardColorGreen = 1,
    RuinCardColorBlue = 2,
    RuinCardColorPurple = 3,
    RuinCardColorGray = 4
} RuinCardColor;

@interface RuinCard : NSObject {
    bool bFaceDown;
    RuinCardColor cardColor;
    int claimValue;
    int stoneValue;
    int stones;
    NSMutableArray *delverDice;
    
}

/*
 Method list from [Object Library.txt]
 > RuinCard
 - bFaceDown         // Used to determine which player(s) can see this card
 - color                // Purple, Blue, Green, Peach, Gray
 - claimValue        // name from rules, delver die total to trigger card claiming.
 - stoneValue        // name from rules, number of stones initially placed on card.
 - stones            // stones currently on the card
 - delverDice        // dice currently on the card

 */

@end
