//
//  CommandLineInterface.m
//  Unearth
//
//  Created by mazerlodge on 9/2/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "CommandLineInterface.h"

@implementation CommandLineInterface

- (id) init {
	bInDebug = false;
	minDebugMsgLevel = -1;
	
	return self;
	
}

- (id) initWithDebugOn: (bool) bDebugOn minDebugMsgLevel: (int) debugLevel {
	
	bInDebug = bDebugOn;
	minDebugMsgLevel = debugLevel;
	
	return self;
	
}

- (NSString * ) getStr: (NSString *) msg {
    NSString *rval = @"NOT_SET";
    
    // TODO: How to scan for strings, fails with large strings.
    // This is OK: upercalafragileistice
    // This isn't: upercalafragileisticex
    // Before making inputVal to an array, this caused 'illegal instruction': upercalafragileisticexpealli
    //    NSString *inMessage = [NSString stringWithCString:&inputVal encoding:NSUTF8StringEncoding];

    char inputVal[255] = {0};// = "NOT_SET";
    printf("%s", [msg UTF8String]);
    scanf("%s", inputVal);
    NSString *inMessage = [[NSString alloc] initWithUTF8String:inputVal];

    rval = inMessage;
    
    return rval;
    
}

- (int) getInt: (NSString *) msg  {
    
    int rval = -1;

    printf("%s", [msg UTF8String]);
    scanf("%i",&rval);
    
    return rval;
    
}

- (float) getFloat: (NSString *) msg {
    
    float rval = 0.0;

    printf("%s", [msg UTF8String]);
    scanf("%f",&rval);

    return rval;
    
}


- (void) put: (NSString *) msg {
    
	[self put:msg withNewline:false];
    
}

- (void) put: (NSString *) msg withNewline: (bool) bAddNewLine {
	
	if (bAddNewLine)
		printf("%s\n", [msg UTF8String]);
	else
		printf("%s", [msg UTF8String]);

	
}

- (void) debugMsg: (NSString *) msg {
	// If debug mode is turned on output the specified message via the command line interface.
	
	[self debugMsg:msg level:0];
	
}

- (void) debugMsg: (NSString *) msg level: (int) msgLevel {
	// If debug mode is turned on output the specified message via the command line interface.
	
	// Add the message level to the message
	msg = [msg stringByAppendingFormat:@"(Severity: %d)\n", msgLevel];
	
	if (bInDebug && (msgLevel >= minDebugMsgLevel))
		[self put:msg];
	
}
@end
