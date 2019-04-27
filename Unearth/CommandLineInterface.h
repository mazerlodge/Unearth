//
//  CommandLineInterface.h
//  Unearth
//
//  Created by mazerlodge on 9/2/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandLineInterface : NSObject {
	bool bInDebug;
	int minDebugMsgLevel;

}

- (id) initWithDebugOn: (bool) bDebugOn minDebugMsgLevel: (int) debugLevel;

- (NSString *) getStr: (NSString *) msg;
- (int) getInt: (NSString *) msg;
- (float) getFloat: (NSString *) msg;

- (void) put: (NSString *) msg;
- (void) put: (NSString *) msg withNewline: (bool) bAddNewLine;

- (void) debugMsg: (NSString *) msg;
- (void) debugMsg: (NSString *) msg level: (int) msgLevel;

@end
