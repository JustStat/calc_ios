//
//  ViewController.m
//  calc
//
//  Created by Kirill Varlamov on 15.07.16.
//  Copyright © 2016 Kirill Varlamov. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"
#import "math.h"

static NSInteger const kMaxResultTextLengh = 11;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *calcTextField;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation ViewController {
    UIButton *currentOperationButton;
    Calculator *calc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    calc = [[Calculator alloc] init];
    [self.calcTextField becomeFirstResponder];
    [calc setInitState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - textFormat


- (IBAction)calcTextChanged:(id)sender {
    
    UITextView *textView = ((UITextView *)sender);
    
    if ((calc.calcState == MCReadOperationState || calc.calcState == MCInitState || calc.calcState == MCDoneCalculation) && textView.text.length > 0) {
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
    
    if (calc.calcState == MCInitState || calc.calcState == MCDoneCalculation) {
        calc.calcState = MCReadFirstNumberState;
        [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
    }
    if (calc.calcState == MCReadOperationState) {
        calc.calcState = MCReadSecondNumberState;
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
    if (calc.calcState == MCReadSecondNumberState) {
        [calc setSecondNumber:@([self.calcTextField.text doubleValue])];
        [self.calcTextField setText:[calc actCalculation]];
        [currentOperationButton.layer setBorderWidth:0];
    }
    if (currentOperationButton) {
        [currentOperationButton.layer setBorderWidth:0];
    }
    calc.currentOperation = (MCCalcOperations)((UIButton *)sender).tag;
    if ([self.calcTextField.text isEqualToString:@"Ошибка"]) {
        [calc setFirstNumber:@(INFINITY)];
    } else {
        [calc setFirstNumber:@([self.calcTextField.text doubleValue])];
    }
    currentOperationButton = (UIButton *)sender;
    [currentOperationButton.layer setBorderWidth:2];
    calc.calcState = MCReadOperationState;
}

- (IBAction)dotButtonClick:(id)sender {
    [self.calcTextField setText:[self.calcTextField.text stringByAppendingString:((UIButton *)sender).titleLabel.text]];
    [self.calcTextField sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (IBAction)clearButtonClick:(id)sender {
    [self.calcTextField setText:@"0"];
    [currentOperationButton.layer setBorderWidth:0];
    if (calc.calcState == MCInitState) {
        [calc setInitState];
    }
    
    if (calc.calcState == MCDoneCalculation) {
        calc.calcState = MCInitState;

    }
    
    if (calc.calcState == MCReadFirstNumberState || calc.calcState == MCReadOperationState) {
        calc.calcState = MCInitState;
        [calc setInitState];
    }
    
    if (calc.calcState == MCReadSecondNumberState) {
        calc.calcState = MCReadOperationState;
        [currentOperationButton.layer setBorderWidth:2];
    }
    [self.clearButton setTitle:@"AC" forState:UIControlStateNormal];
}

- (IBAction)equalButtonClick:(id)sender {
        switch (calc.calcState) {
            case MCReadSecondNumberState:
                [calc setSecondNumber:@([self.calcTextField.text doubleValue])];
                break;
            case MCReadFirstNumberState: {
                 [calc setFirstNumber:@([self.calcTextField.text doubleValue])];
                break;
            }
            case MCReadOperationState: {
                [calc setSecondNumber:@([self.calcTextField.text doubleValue])];
                break;
            }
            case MCDoneCalculation: {
                NSScanner *scanner = [NSScanner scannerWithString:self.calcTextField.text];
                if ([scanner scanDouble:NULL] && [scanner isAtEnd]) {
                    [calc setFirstNumber:@([self.calcTextField.text doubleValue])];
                } else {
                    [calc setFirstNumber:@(INFINITY)];
                }
                break;
            }
            default:
                return;
        }

    [self.calcTextField setText:[calc actCalculation]];
    [currentOperationButton.layer setBorderWidth:0];
}

- (IBAction)signButtonClick:(id)sender {
    [self.calcTextField setText:@(self.calcTextField.text.doubleValue * -1).stringValue];
}

- (IBAction)persentButtonClick:(id)sender {
    [self.calcTextField setText:@(self.calcTextField.text.doubleValue * 0.01).stringValue];
}

- (IBAction)clearMemoryButtonClick:(id)sender {
    [calc setMemoryValue:nil Operation:MCClearMemory];
}

- (IBAction)readMemoryButtonClick:(id)sender {
    [self.calcTextField setText:[calc getMemoryValue].stringValue];
}

- (IBAction)saveMemoryButtonClick:(id)sender {
    if (fabs([self.calcTextField.text doubleValue]) > DBL_MAX || [self.calcTextField.text isEqualToString:@"Ошибка"]) {
        return;
    }
    [calc setMemoryValue:@([self.calcTextField.text doubleValue]) Operation:MCSaveMomory];
}

- (IBAction)plusMemoryButtonClick:(id)sender {
    if (fabs([self.calcTextField.text doubleValue]) > DBL_MAX || [self.calcTextField.text isEqualToString:@"Ошибка"]) {
        return;
    }
    [calc setMemoryValue:@([self.calcTextField.text doubleValue]) Operation:MCPlusMemory];
}

- (IBAction)minusMemoryButtonClick:(id)sender {
    if (fabs([self.calcTextField.text doubleValue]) > DBL_MAX || [self.calcTextField.text isEqualToString:@"Ошибка"]) {
        return;
    }
    [calc setMemoryValue:@([self.calcTextField.text doubleValue]) Operation:MCMinusMemory];

}

@end
