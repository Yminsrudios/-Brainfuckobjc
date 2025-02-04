#import <Foundation/Foundation.h>

@interface BrainfuckInterpreter : NSObject

- (void)interpret:(NSString *)code;

@end

@implementation BrainfuckInterpreter {
    NSMutableArray *_memory;
    NSInteger _pointer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _memory = [NSMutableArray arrayWithCapacity:30000];
        for (int i = 0; i < 30000; i++) {
            [_memory addObject:@0];
        }
        _pointer = 0;
    }
    return self;
}

- (void)interpret:(NSString *)code {
    for (int i = 0; i < code.length; i++) {
        unichar instruction = [code characterAtIndex:i];
        
        switch (instruction) {
            case '>':
                _pointer++;
                if (_pointer >= 30000) {
                    _pointer = 0;
                }
                break;
            case '<':
                _pointer--;
                if (_pointer < 0) {
                    _pointer = 29999;
                }
                break;
            case '+':
                _memory[_pointer] = @([_memory[_pointer] integerValue] + 1);
                break;
            case '-':
                _memory[_pointer] = @([_memory[_pointer] integerValue] - 1);
                break;
            case '.':
                printf("%c", [_memory[_pointer] intValue]);
                break;
            case ',': {
                char input;
                scanf(" %c", &input);
                _memory[_pointer] = @((int)input);
                break;
            }
            case '[': {
                if ([_memory[_pointer] integerValue] == 0) {
                    int balance = 1;
                    while (balance > 0 && i < code.length) {
                        i++;
                        unichar nextInstruction = [code characterAtIndex:i];
                        if (nextInstruction == '[') {
                            balance++;
                        } else if (nextInstruction == ']') {
                            balance--;
                        }
                    }
                }
                break;
            }
            case ']': {
                if ([_memory[_pointer] integerValue] != 0) {
                    int balance = 1;
                    while (balance > 0 && i >= 0) {
                        i--;
                        unichar prevInstruction = [code characterAtIndex:i];
                        if (prevInstruction == ']') {
                            balance++;
                        } else if (prevInstruction == '[') {
                            balance--;
                        }
                    }
                    i--;
                }
                break;
            }
            default:
                break;
        }
    }
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *brainfuckCode = @">++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.";
        BrainfuckInterpreter *interpreter = [[BrainfuckInterpreter alloc] init];
        [interpreter interpret:brainfuckCode];
    }
    return 0;
}
