//
//  Util.m
//  TracePlatform
//
//  Created by lym on 2017/5/2.
//  Copyright © 2017年 ehsureTec. All rights reserved.
//
#define NaviH            ([[UIScreen mainScreen] bounds].size.height >= 812 ? 88 : 64) // 812是iPhoneX的高度(括号不能去掉！！！)
#define kScreen_Width    [UIScreen mainScreen].bounds.size.width
#define kScreen_Height   [UIScreen mainScreen].bounds.size.height
#import "Util.h"
#import <MBProgressHUD.h>
@interface Util()
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation Util

+ (void)setTextFieldMaxLengthWithTextField:(UITextField *)textField maxLength:(NSInteger)maxLength {
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {//没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > maxLength) {
                textField.text = [toBeString substringToIndex:maxLength];
            }
        }else {//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else {//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > maxLength) {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }
}

+ (NSMutableAttributedString *)changeColorCharWithOriginalString:(NSString *)originalString needChangCorolCharArr:(NSArray *)changeColorCharArr targetColor:(UIColor *)targetColor{
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
    
    for (NSString *searchStr in changeColorCharArr) {
        
        NSError *error = NULL;
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:searchStr options:NSRegularExpressionIgnoreMetacharacters error:&error];
        NSArray *rangeArray = [expression matchesInString:originalString options:0 range:NSMakeRange(0, originalString.length)];
        
        for (NSTextCheckingResult *result in rangeArray) {
            
            NSRange range = [result range];
            if (range.location != NSNotFound) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:targetColor range:NSMakeRange(range.location,range.length)];
            }
            
        }
        
    }
    return attributedString;
}


/**
 获取当前屏幕显示的viewcontroller
 
 @return 当前正在显示的viewcontroller
 */
+ (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    // 获取默认的window
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    // 获取window的rootViewController
    result = window.rootViewController;
    
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}



//根据字符串长度获取对应的宽度或者高度
+ (CGFloat)stringText:(NSString *)text font:(CGFloat)font isHeightFixed:(BOOL)isHeightFixed fixedValue:(CGFloat)fixedValue
{
    CGSize size;
    if (isHeightFixed) {
        size = CGSizeMake(MAXFLOAT, fixedValue);
    } else {
        size = CGSizeMake(fixedValue, MAXFLOAT);
    }
    
    CGSize resultSize;
    //返回计算出的size
    resultSize = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size;
    
    if (isHeightFixed) {
        return resultSize.width;
    } else {
        return resultSize.height;
    }
}


/**
 *  日期格式处理方法
 */
+ (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

#pragma mark - NSUserDefaults 存储、获取、删除
+ (void)saveInfoObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}


+ (id)getInfoObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)removeInfoObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}


//创建提示弹框并展示
+ (void)showMessageWithView:(UIView *)view Title:(NSString *)title {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.7;
    //    hud.label.text = title;
    hud.detailsLabel.text = title;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:18];
    [hud setOffset:CGPointMake(0, -NaviH)];
    [hud hideAnimated:YES afterDelay:2];
    
}


//创建提示弹框并展示
+ (void)showMessageWithView:(UIView *)view Title:(NSString *)title HideAfter:(NSTimeInterval)time {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.7;
    //    hud.label.text = title;
    hud.detailsLabel.text = title;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:18];
    [hud setOffset:CGPointMake(0, -NaviH)];
    [hud hideAnimated:YES afterDelay:time];
    
}

//创建提示弹框并展示
+ (void)showMessageWithView:(UIView *)view Title:(NSString *)title Image:(NSString *)image HideAfter:(NSTimeInterval)time {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.7;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
//    hud.label.text = title;
    hud.detailsLabel.text = title;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:18];
    [hud setOffset:CGPointMake(0, -NaviH)];
    [hud hideAnimated:YES afterDelay:time];

}

//创建提示弹框并展示(可选位置0顶部\1中间\2底部)
+ (void)showMessageWithView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName offsetType:(NSInteger)offsetType HideAfter:(NSTimeInterval)time {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.7;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//    hud.label.text = title;
    hud.detailsLabel.text = title;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:18];
    if (offsetType == 0) {//顶部
        [hud setOffset:CGPointMake(0, -kScreen_Height/2+NaviH)];
    }else if (offsetType == 1) {//中部
        [hud setOffset:CGPointMake(0, -NaviH)];
    }else if (offsetType == 2) {//底部
        [hud setOffset:CGPointMake(0, kScreen_Height/2-NaviH)];
    }
    [hud hideAnimated:YES afterDelay:time];
    
}


//创建提示弹框并展示(可选位置0顶部\1中间\2底部)
+ (void)translucentYESShowMessageWithView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName offsetType:(NSInteger)offsetType HideAfter:(NSTimeInterval)time {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.7;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    //    hud.label.text = title;
    hud.detailsLabel.text = title;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:18];
    if (offsetType == 0) {//顶部
        [hud setOffset:CGPointMake(0, -kScreen_Height/2+NaviH+NaviH)];
    }else if (offsetType == 1) {//中部
        [hud setOffset:CGPointMake(0, -NaviH)];
    }else if (offsetType == 2) {//底部
        [hud setOffset:CGPointMake(0, kScreen_Height/2-NaviH)];
    }
    [hud hideAnimated:YES afterDelay:time];
    
}


//字典转json格式字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}




//可以删除NSString中的数字、符号，或者修改其中的字符
+ (NSString *)stringDeleteString:(NSString *)str {
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == '"' || c == '.' || c == ',' || c == '(' || c == ')' || c == '-') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}




//计算字符串size
+ (CGSize)sizeWithString:(NSString *)string font:(CGFloat)font {
    UIFont *font1 = [UIFont systemFontOfSize:font];
    CGSize sizeWord = [string sizeWithFont:font1 constrainedToSize:CGSizeMake(1000.0, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
    return sizeWord;
}


//获取当前时间字符串
+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//比较两个日期的大小
+ (int)compareDate:(NSString *)date01 withDate:(NSString *)date02 {
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
            
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


//button点击后的设置
+ (void)setBtnEnabledWithBtn:(UIButton *)btn Time:(int)outTime YesColor:(UIColor *)yesColor NoColor:(UIColor *)noColor {
    
    __block int timeout=outTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                [btn setBackgroundColor:yesColor];
                btn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                [btn setBackgroundColor:noColor];
                btn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
        
    });
    dispatch_resume(_timer);
    
}

//判断字符串是否为空
+ (BOOL)isNullWithStr:(NSString *)str {
    if ( str == nil
        || str == NULL
        || [str isKindOfClass:[NSNull class]]
        || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]== 0) {
        return YES;
    }else {
        return NO;
    }
}

//判断字符串是否为空(包括空字符串)
+ (BOOL)isNullWithString:(NSString *)str {
    if ( str == nil
        || str == NULL
        || [str isKindOfClass:[NSNull class]]
        || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]== 0
        || [str isEqualToString:@""]) {
        return YES;
    }else {
        return NO;
    }
}

//邮箱验证
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile {
    //    /**
    //     * 移动号段正则表达式
    //     */
    //    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    //    /**
    //     * 联通号段正则表达式
    //     */
    //    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    //    /**
    //     * 电信号段正则表达式
    //     */
    //    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    //
    //    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    //    BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
    //    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    //    BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
    //    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    //    BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
    //
    //    if (isMatch1 || isMatch2 || isMatch3) {
    //        return YES;
    //    }else{
    //        return NO;
    //    }
    
    
    //不做号段校验，暂时判断是否为11位数字
    if (mobile.length != 11) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:mobile]) {
        return YES;
    }
    return NO;
    
}


//正则匹配用户密码,6-18位数字和字母组合
+ (BOOL)validatePSW:(NSString *)psw {
    
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:psw];
    
    return isMatch;
}


//正则匹验证码,6位的数字
+ (BOOL)validateCode:(NSString *)code {
    
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:code];
    
    return isMatch;
}


+(BOOL)validateUserID:(NSString *)userID {
    //长度不为18的都排除掉
    if (userID.length!=18) { return NO; }
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2]; BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    if (!flag) {
        
        return flag; //格式错误
        
    }else { //格式正确在判断是否合法 //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0; for(int i = 0;i < 17;i++) {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue]; NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2) { if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) { return YES; }else { return NO; } }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
                return YES;
                
            } else {
                return NO;
                
            }
            
        }
        
    }
    
}

+ (BOOL)isSocialCredit18Number:(NSString *)socialCreditNum
{
    if(socialCreditNum.length != 18){
        return NO;
    }
    
    NSString *scN = @"^([0-9ABCDEFGHJKLMNPQRTUWXY]{2})([0-9]{6})([0-9ABCDEFGHJKLMNPQRTUWXY]{9})([0-9Y])$";
    NSPredicate *regextestSCNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", scN];
    if (![regextestSCNum evaluateWithObject:socialCreditNum]) {
        return NO;
    }
    
    NSArray *ws = @[@1,@3,@9,@27,@19,@26,@16,@17,@20,@29,@25,@13,@8,@24,@10,@30,@28];
    NSDictionary *zmDic = @{@"A":@10,@"B":@11,@"C":@12,@"D":@13,@"E":@14,@"F":@15,@"G":@16,@"H":@17,@"J":@18,@"K":@19,@"L":@20,@"M":@21,@"N":@22,@"P":@23,@"Q":@24,@"R":@25,@"T":@26,@"U":@27,@"W":@28,@"X":@29,@"Y":@30};
    NSMutableArray *codeArr = [NSMutableArray array];
    NSMutableArray *codeArr2 = [NSMutableArray array];
    
    codeArr[0] = [socialCreditNum substringWithRange:NSMakeRange(0,socialCreditNum.length-1)];
    codeArr[1] = [socialCreditNum substringWithRange:NSMakeRange(socialCreditNum.length-1,1)];
    
    int sum = 0;
    
    for (int i = 0; i < [codeArr[0] length]; i++) {
        
        [codeArr2 addObject:[codeArr[0] substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSScanner* scan;
    int val;
    for (int j = 0; j < codeArr2.count; j++) {
        scan = [NSScanner scannerWithString:codeArr2[j]];
        if (![scan scanInt:&val] && ![scan isAtEnd]) {
            codeArr2[j] = zmDic[codeArr2[j]];
        }
    }
    
    
    for (int x = 0; x < codeArr2.count; x++) {
        sum += [ws[x] intValue]*[codeArr2[x] intValue];
    }
    
    
    int c18 = 31 - (sum % 31);
    
    for (NSString *key in zmDic.allKeys) {
        
        if (zmDic[key]==[NSNumber numberWithInt:c18]) {
            if (![codeArr[1] isEqualToString:key]) {
                return NO;
            }
        }
    }
    
    return YES;
}


+ (NSString*)isOrNoUserNameStyle:(NSString *)userName {
    
    NSString * message;
    
    if (userName.length<6) {
        message=@"账号不能少于6位，请您重新输入";
    }else if (userName.length>20) {
        message=@"最大长度为20位，请您重新输入";
    }else if ([self JudgeTheillegalCharacter:userName]) {
        message=@"账号不能包含特殊字符，请您重新输入";
    }
//    else if (![self judgePassWordLegal:userName])
//    {
//        message=@"密码必须同时包含字母和数字";
//    }
    else{
        message=@"right";
    }
    
    return message;
    
}



+ (NSString*)isOrNoPasswordStyle:(NSString *)passWordName {
    
    NSString * message;
    
    if (passWordName.length<8) {
        message=@"密码不能少于8位，请您重新输入";
    }else if (passWordName.length>20) {
        message=@"密码最大长度为20位，请您重新输入";
    }else if ([self JudgeTheillegalCharacter:passWordName]) {
        message=@"密码不能包含特殊字符，请您重新输入";
    }
//    else if (![self judgePassWordLegal:passWordName])
//    {
//        message=@"密码必须同时包含字母和数字";
//    }
    else{
          message=@"right";
    }
    
    return message;
    
}

+(BOOL)JudgeTheillegalCharacter:(NSString *)content {
    
    //提示标签不能输入特殊字符
//      NSString *str =@"[~!/@#$%^&#$%^&amp;*()-_=+\\|[{}];:\'\",&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&gt;/?]+";
    
    //    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    
    NSString *str =@"^[A-Za-z0-9]+$";

    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    if (![emailTest evaluateWithObject:content]) {
        
        return YES;
        
    }
    
    return NO;
    
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    
    BOOL result ;
    
    // 判断长度大于8位后再接着判断是否同时包含数字和大小写字母
    
    NSString * regex =@"(?![0-9A-Z]+$)(?![0-9a-z]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$ ";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    result = [pred evaluateWithObject:pass];
    
    return result;
    
}


+ (BOOL)isUserNameWithStr:(NSString *)content {
    
    NSString *str = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    if ([predicate evaluateWithObject:content]) {
        return YES;
    }
    
    return NO;
    
}


+ (BOOL)isHaveSpecialCharWithStr:(NSString *)content {
    
    NSString *str = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    if ([predicate evaluateWithObject:content]) {
        return false;
    }
    
    return true;
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1024.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1024.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    
    
    
    return data;
}



+ (UIImage*)imageCompressWithSimple:(UIImage*)image {
    CGSize size = image.size;
    CGFloat scale = 1.0;
    //TODO:KScreenWidth屏幕宽
    if (size.width > kScreen_Width || size.height > kScreen_Height) {
        if (size.width > size.height) {
            scale = kScreen_Width / size.width;
        }else {
            scale = kScreen_Height / size.height;
        }
    }
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize secSize =CGSizeMake(scaledWidth, scaledHeight);
    //TODO:设置新图片的宽高
    //    UIGraphicsBeginImageContext(secSize); // this will crop
    UIGraphicsBeginImageContextWithOptions(secSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (BOOL)isTelNum:(NSString *)telNum {
    //固话，区号（3-4位）- 号码（7-8位）
    NSString *checkStr = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|14[5|7|9]|15[0-9]|17[0|1|3|5|6|7|8]|18[0-9])\\d{8}$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", checkStr];
    return [predicate evaluateWithObject:telNum];
}


+ (BOOL)isPostcode:(NSString *)postcode {
    //邮编，校验前两位
    NSString *checkStr = @"^(0[1234567]|1[012356]|2[01234567]|3[0123456]|4[01234567]|5[1234567]|6[1234567]|7[012345]|8[013456])\\d{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", checkStr];
    return [predicate evaluateWithObject:postcode];
}


/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)newCompressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    NSData * data = UIImageJPEGRepresentation(image, 0.4);
    CGFloat dataKBytes = data.length/1024.0;
    CGFloat maxQuality = 0.7f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1024.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    
    
    return data;
}



+ (UIImage*)newImageCompressWithSimple:(UIImage*)image {
    CGSize size = image.size;
    CGFloat scale = 0.5;
    //    //TODO:KScreenWidth屏幕宽
    //    if (size.width > kMainWidth || size.height > kMainHeight) {
    //        if (size.width > size.height) {
    //            scale = kMainWidth / size.width;
    //        }else {
    //            scale = kMainHeight / size.height;
    //        }
    //    }
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize secSize =CGSizeMake(scaledWidth, scaledHeight);
    //TODO:设置新图片的宽高
    //    UIGraphicsBeginImageContext(secSize); // this will crop
    UIGraphicsBeginImageContextWithOptions(secSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
