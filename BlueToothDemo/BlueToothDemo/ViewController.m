//
//  ViewController.m
//  BlueToothDemo
//
//  Created by ly on 2018/9/14.
//  Copyright © 2018年 ly. All rights reserved.
//

#import "ViewController.h"
#import "WFXFAgent.h"

@interface ViewController ()
@property (nonatomic, strong)WFXFAgent *agent;
@property (nonatomic, strong)UITextView *textView;
@end

@implementation ViewController

/**
 {swith}
 
 {light}

 {temperature}
 
 {model}
 
 {color}
 **/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, CGRectGetWidth(self.view.frame)-20, 70)];
    tip.font = [UIFont systemFontOfSize:10];
    tip.text = @"{switch}灯  {switch}冷暖灯 灯{switch} 冷暖灯{switch} 请{switch}灯 请{switch}冷暖灯 麻烦{switch}灯 麻烦{switch}灯 {light}一点 {temperature}一点 把灯{switch} {model}模式 打开{model}模式 开启{model}模式 {color}色";
    tip.numberOfLines = 0;
    [self.view addSubview:tip];
    
    self.agent = [[WFXFAgent alloc] init];
    self.agent.vc  = self;
    
//
//    UIButton *btn = ({
//        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(50, 100, 100, 100);
//        btn.backgroundColor = [UIColor greenColor];
//        [btn setTitle:@"唤醒" forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(wakeup) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//        btn;
//    });
//
    
    UIButton *btn2 = ({
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(200, 100, 100, 100);
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:@"录音" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    
    
    UIButton *btn3 = ({
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50, 250, 100, 100);
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:@"停止录音" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    
    
    self.textView = ({
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btn3.frame)+10, CGRectGetWidth(self.view.frame)-20, 300)];
        textView.backgroundColor = [UIColor blueColor];
        textView.textColor = [UIColor blackColor];
        [self.view addSubview:textView];
        
        textView;
    });
}

- (void)record {
    [self.agent record];
}

-  (void)stopRecord  {
    [self.agent stopRecord];
}

- (void)message:(NSString *)message {
    self.textView.text = [NSString stringWithFormat:@"%@\n%@",self.textView.text,message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
