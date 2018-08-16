//
//  UnearthGameFactory.m
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthGameFactory.h"


@implementation UnearthGameFactory

- (id) init {
    
    return self;
    
}


- (void) showUsage {
    // Display appropriate invocation options.
    
    printf("Usage: unearth -action {dotest} -test 1 \n");
    
    
}

- (bool) validateArguments: (ArgParser *) argParser {
    // Return true if the params specified are valid and complete.
    
    bool bRval = true;
    NSString *action = @"NOT_SET";
    
    if ([argParser isInArgs:@"-action" withAValue:true]) {
        action = [argParser getArgValue:@"-action"];
    }
    else {
        NSLog(@"Error: Missing required parameter: -action.  Can not continue.\n");
        bRval = false;
    }
    
    // If action is dotest, must also have a -test arg w/ a test number.
    if (([action isEqualToString:@"dotest"])
        && (![argParser isInArgs:@"-test" withAValue:true])) {
        NSLog(@"Error: Detected -action of dotest, missing required parameter: -test testID.  Can not continue.\n");
        bRval = false;
    }
    
    if ([argParser isInArgs:@"-debug" withAValue:false])
        NSLog(@"Info: Debug parameter detected.\n");
    
    
    return bRval;
    
}

- (UnearthGameEngine *) makeGame {
    
    // TODO: Define set of test params to be used with this generic method.
    UnearthGameEngine *uge = [[UnearthGameEngine alloc] init];
    
    // TODO: Create a populated ArgParser object, may require new 'argParserFromString' type method.
    NSString *params = @"-action dotest -test 1 -debug";
    ArgParser *ap = [[ArgParser alloc] init];
    [ap populateArgParserFromString:params];
    
    
    return uge;
    
    
}

- (UnearthGameEngine *) makeGameWithArgs: (ArgParser *) ap {
    
    // TODO: Evaluate ArgParser to determine details of game build.

    // TODO: Define set of test params to be used with this generic method.
    UnearthGameEngine *uge = [[UnearthGameEngine alloc] init];

    return uge;
    
}


@end
