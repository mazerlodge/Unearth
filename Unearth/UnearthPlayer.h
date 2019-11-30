//
//  UnearthPlayer.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DelverDie.h"
#import "DelverCard.h"
#import "RuinCard.h"
#import "RandomEngine.h"

typedef enum UnearthPlayerType : NSUInteger {
    UnearthPlayerHuman = 0,
    UnearthPlayerAI = 1} UnearthPlayerType;



@interface UnearthPlayer : NSObject {
    
    NSString *playerName;
    UnearthPlayerType playerType;
    DelverDieColor dieColor;
	NSMutableArray *delverCards;
	NSMutableArray *ruinCards;
	RandomEngine *re;
	
}

- (id) initWithPlayerType: (UnearthPlayerType) type dieColor: (DelverDieColor) color playerName: (NSString *) name randomEngine: (RandomEngine *) randomEngine;


- (DelverDieColor) dieColor;
- (NSString *) playerName;
- (NSUInteger) addDelverCard: (DelverCard *) card;
- (NSUInteger) addRuinCard: (RuinCard *) card;
- (DelverCard *) playDelverCard: (int) cardID;
- (int) roleDie: (DelverDieSize) dieSize;

- (NSString *) toString;

/*
 Method list from [Object Library.txt]
 > UnearthPlayer
 - name                // For output and identification
 - type                 // human or ai
 - dieColor            // one of red, green, yellow, blue, to come from DelverDie.h based enum.
 - delverCards        // current delver cards held by this player
 - delverDice         // current held delver dice, available to roll
 - ruinsCards         // includes one faceDown
 - hexMap            // arrangement of owned stones and wonders
 
 */

@end
