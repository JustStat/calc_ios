//
//  ViewController.m
//  calc
//
//  Created by Kirill Varlamov on 15.07.16.
//  Copyright © 2016 Kirill Varlamov. All rights reserved.
//

#import "ViewController.h"
#import "math.h"

static NSInteger const kMaxResultTextLengh = 11;
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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *calcTextField;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation ViewController {
    MCCalcState calcState;
    MCCalcOperations currentOperation;
    double a;
    double b;
    double currentCalculation;
    double memoryValue;
    UIButton *currentOperationButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.calcTextField becomeFirstResponder];
    [self setInitState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setInitState {
    a = 0;
    b = 0;
    calcState = MCInitState;
    currentOperation = MCNoOperation;
    currentCalculation = 0;
}

- (void)actCalculation {
    switch (calcState) {
        case MCReadSecondNumberState:
            b = [self.calcTextField.text doubleValue];
            break;
        case MCDoneCalculation: {
            a = currentCalculation;
            break;
        }
        case MCReadFirstNumberState: {
            a = [self.calcTextField.text doubleValue];
            break;
        }
        case MCReadOperationState: {
            b = [self.calcTextField.text doubleValue];
            break;
        }
        default:
            return;
    }
    
    switch (currentOperation) {
        case MCPlusOperation:
            currentCalculation = a + b;
            break;
        case MCMinusOperation: {
            currentCalculation = a - b;
            break;
        }
        case MCMultOperation: {
            currentCalculation = a * b;
            break;
        }
        case MCDivOperation: {
            if (b != 0) {
                currentCalculation = a / b;
            } else {
                [self.calcTextField setText:@"Ошибка"];
                return;
            }
            break;
        }
        default:
            currentCalculation = a;
            return;
    }
    if (fabs(currentCalculation) > DBL_MAX) {
        [self.calcTextField setText:@"Ошибка"];
    } else {
        [self.calcTextField setText:[@(currentCalculation) stringValue]];
    }
    calcState = MCDoneCalculation;
    [currentOperationButton.layer setBorderWidth:0];
}

#pragma mark - textFormat


- (IBAction)calcTextChanged:(id)sender {
    
    UITextView *textView = ((UITextView *)sender);
    
    if ((calcState == MCReadOperationState || calcState == MCInitState || calcState == MCDoneCalculation) && textView.text.length > 0) {
        [textView setText:[textView.text substringWithRange:NSMakeRange(textView.text.length - 1, 1)]];
    }
    
    if ([textView.text hasPrefix:@"0"] && ![textView.text hasPrefix:@"0."]) {
        [textView setText:[textView.text substringFromIndex:1]];
    }
    
    if ([textView.text isEqualToString:@""]) {
        [textView setText:@"0"];
    }
    
    if (textView.text.length >= kMaxResultTextLengh) {
        [textView setText:[textView.text substringToIndex:textView.text.length - 1]];
    }
    if ([textView.text hasSuffix:@"."] && [textView.text rangeOfString:@"." ].location != textView.text.length - 1) {
        [textView setText:[textView.text substringToIndex:textView.text.length - 1]];
    }
    
    if (calcState == MCInitState || calcState == MCDoneCalculation) {
        calcState = MCReadFirstNumberState;
        [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
    }
    if (calcState == MCReadOperationState) {
        calcState = MCReadSecondNumberState;
        [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
        if (currentOperationButton) {
            [currentOperationButton.layer setBorderWidth:0];
        }
    }
}

#pragma mark - buttonActions

- (IBAction)digitButtonClick:(id)sender {
    [self.calcTextField setText:[self.calcTextField.text stringByAppendingString:((UIButton *)sender).titleLabel.text]];
    [self.calcTextField sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (IBAction)operationButtonClick:(id)sender {
    if (calcState == MCReadSecondNumberState) {
        [self actCalculation];
    }
    if (currentOperationButton) {
        [currentOperationButton.layer setBorderWidth:0];
    }
    currentOperation = (MCCalcOperations)((UIButton *)sender).tag;
    if ([self.calcTextField.text isEqualToString:@"Ошибка"]) {
        a = INFINITY;
    } else {
        a = [self.calcTextField.text doubleValue];
    }
    currentOperationButton = (UIButton *)sender;
    [currentOperationButton.layer setBorderWidth:2];
    calcState = MCReadOperationState;
}

- (IBAction)dotButtonClick:(id)sender {
    [self.calcTextField setText:[self.calcTextField.text stringByAppendingString:((UIButton *)sender).titleLabel.text]];
    [self.calcTextField sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (IBAction)clearButtonClick:(id)sender {
    [self.calcTextField setText:@"0"];
    [currentOperationButton.layer setBorderWidth:0];
    if (calcState == MCInitState) {
        [self setInitState];
    }
    
    if (calcState == MCReadFirstNumberState || calcState == MCDoneCalculation || calcState ==MCReadOperationState) {
        calcState = MCInitState;
        [self setInitState];
    }
    
    if (calcState == MCReadSecondNumberState) {
        calcState = MCReadOperationState;
        [currentOperationButton.layer setBorderWidth:2];
    }
    [self.clearButton setTitle:@"AC" forState:UIControlStateNormal];
}

- (IBAction)equalButtonClick:(id)sender {
    [self actCalculation];
}

- (IBAction)signButtonClick:(id)sender {
    [self.calcTextField setText:@(self.calcTextField.text.doubleValue * -1).stringValue];
}

- (IBAction)persentButtonClick:(id)sender {
    [self.calcTextField setText:@(self.calcTextField.text.doubleValue * 0.01).stringValue];
}

- (IBAction)clearMemoryButtonClick:(id)sender {
    memoryValue = 0;
}

- (IBAction)readMemoryButtonClick:(id)sender {
    [self.calcTextField setText:@(memoryValue).stringValue];
}

- (IBAction)saveMemoryButtonClick:(id)sender {
    if (fabs(currentCalculation) > DBL_MAX || [self.calcTextField.text isEqualToString:@"Ошибка"]) {
        return;
    }
    memoryValue = [self.calcTextField.text doubleValue];
}

- (IBAction)plusMemoryButtonClick:(id)sender {
    if (fabs(currentCalculation) > DBL_MAX || [self.calcTextField.text isEqualToString:@"Ошибка"]) {
        return;
    }
    memoryValue += [self.calcTextField.text doubleValue];
}

- (IBAction)minusMemoryButtonClick:(id)sender {
    if (fabs(currentCalculation) > DBL_MAX || [self.calcTextField.text isEqualToString:@"Ошибка"]) {
        return;
    }
    memoryValue -= [self.calcTextField.text doubleValue];
}

@end
