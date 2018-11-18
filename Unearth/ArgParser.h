//
//  ArgParser.h
//  ArgParserTest
//
//  Created by mazerlodge on 6/9/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#ifndef ArgParser_h
#define ArgParser_h

#import <Foundation/Foundation.h>
#import "CommandLineInterface.h"

@interface ArgParser : NSObject {
    
    NSArray *argsList;
    
}

- (id) initWithArgs: (NSArray *) args;
- (bool) populateArgParserFromString: (NSString *) paramString preserveZeroParam: (bool) bPreserveZero;
- (bool) addArgsFromString: (NSString *) paramString;
- (bool) isInArgs: (NSString *) name withAValue: (bool) bWithValue;
- (NSString *) getArgValue: (NSString *) name;
- (bool) doesArg: (NSString *) name haveValue: (NSString *) value;
- (void) dumpArgsToCLI: (CommandLineInterface *) cli;
- (NSString *) getArgByNumber: (NSUInteger) argNumber;

@end



#endif /* ArgParser_h */
