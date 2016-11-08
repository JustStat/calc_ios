//
//  Calculator.h
//  calc
//
//  Created by Kirill Varlamov on 01.11.16.
//  Copyright © 2016 Kirill Varlamov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MCInitState,
    MCReadFirstNumberState,
    MCReadOperationState,
    MCReadSecondNumberState,
    MCDoneCalculation
} MCCalcState;

typedef enum {
    MCNoOperation,
    MCPlusOperation,
    MCMinusOperation,
    MCMultOperation,
    MCDivOperation
} MCCalcOperations;

typedef enum {
    MCClearMemory,
    MCSaveMomory,
    MCPlusMemory,
    MCMinusMemory
} MCMemoryOperations;


@interface Calculator : NSObject

@property MCCalcState calcState;
@property MCCalcOperations currentOperation;

- (void)setInitState;
- (NSString *)actCalculation;
- (void)setFirstNumber:(NSNumber *)number;
- (void)setSecondNumber:(NSNumber *)number;
- (void)setOperation:(MCCalcOperations)operation;
- (void)setMemoryValue:(NSNumber *)value Operation:(MCMemoryOperations)operation;
- (NSNumber *)getMemoryValue;

@end
