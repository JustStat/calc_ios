//
//  MCMainTextView.m
//  calc
//
//  Created by Kirill Varlamov on 25.10.16.
//  Copyright © 2016 Kirill Varlamov. All rights reserved.
//

#import "MCMainTextView.h"

@implementation MCMainTextView

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

@end
