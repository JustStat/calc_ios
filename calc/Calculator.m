//
//  Calculator.m
//  calc
//
//  Created by Kirill Varlamov on 01.11.16.
//  Copyright © 2016 Kirill Varlamov. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator {
    NSNumber *a;
    NSNumber *b;
    NSNumber *currentCalculation;
    NSNumber *memoryValue;
}

- (void)setInitState {
    self.calcState = MCInitState;
    self.currentOperation = MCNoOperation;
    memoryValue = @0;
}

- (NSString *)actCalculation {
    switch (self.currentOperation) {
        case MCPlusOperation:
            currentCalculation = @([a doubleValue] + [b doubleValue]);
            break;
        case MCMinusOperation: {
            currentCalculation = @([a doubleValue] - [b doubleValue]);
            break;
        }
        case MCMultOperation: {
            currentCalculation = @([a doubleValue] * [b doubleValue]);
            break;
        }
        case MCDivOperation: {
            if ([b doubleValue] != 0) {
                currentCalculation = @([a doubleValue] / [b doubleValue]);
            } else {
                return @"Ошибка";
            }
            break;
        }
        default:
            currentCalculation = a;
            return [currentCalculation stringValue];
    }
    if (fabs([currentCalculation doubleValue]) > DBL_MAX || isnan(currentCalculation.doubleValue) || isinf(currentCalculation.doubleValue)) {
        return @"Ошибка";
    } else {
        self.calcState = MCDoneCalculation;
        return [currentCalculation stringValue];
    }
}

#pragma mark - Setters

- (void)setFirstNumber:(NSNumber *)number {
    a = number;
}

- (void)setSecondNumber:(NSNumber *)number {
    b = number;
}

- (void)setOperation:(MCCalcOperations)operation {
    self.currentOperation = operation;
}

- (void)setMemoryValue:(NSNumber *)value Operation:(MCMemoryOperations)operation {
    switch (operation) {
        case MCSaveMomory:
            memoryValue = value;
            break;
        case MCPlusMemory:
            memoryValue = @([memoryValue doubleValue] + [value doubleValue]);
            break;
        case MCMinusMemory:
            memoryValue = @([memoryValue doubleValue] - [value doubleValue]);
            break;
        case MCClearMemory:
            memoryValue = @0;
        default:
            break;
    }
}

- (NSNumber *)getMemoryValue {
    return memoryValue;
}

@end
