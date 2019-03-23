//
//  Util.h
//  TracePlatform
//
//  Created by lym on 2017/5/2.
//  Copyright © 2017年 ehsureTec. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Util : NSObject

#pragma mark - 其它

//限制textfield输入框的文本的长度
+ (void)setTextFieldMaxLengthWithTextField:(UITextField *)textField maxLength:(NSInteger)maxLength;

/*
 *originalString        原始字符串
 *changeColorCharArr    原始字符串中需要改变的字符的数组
 *targetColor           要改变的颜色
 */
+ (NSMutableAttributedString *)changeColorCharWithOriginalString:(NSString *)originalString needChangCorolCharArr:(NSArray *)changeColorCharArr targetColor:(UIColor *)targetColor;

//获取当前页面控制器
+ (UIViewController *)getCurrentVC;

//button被点击后的设置
+ (void)setBtnEnabledWithBtn:(UIButton *)btn Time:(int)outTime YesColor:(UIColor *)yesColor NoColor:(UIColor *)noColor;

#pragma mark - 弹框提示
//创建提示弹框并展示
+ (void)showMessageWithView:(UIView *)view Title:(NSString *)title;

//创建提示弹框并展示
+ (void)showMessageWithView:(UIView *)view Title:(NSString *)title HideAfter:(NSTimeInterval)time;

//创建提示弹框并展示
+ (void)showMessageWithView:(UIView *)view Title:(NSString *)title Image:(NSString *)image HideAfter:(NSTimeInterval)time;

//创建提示弹框并展示(可选位置offsetType 0顶部\1中间\2底部)
+ (void)showMessageWithView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName offsetType:(NSInteger)offsetType HideAfter:(NSTimeInterval)time;

//创建提示弹框并展示(可选位置0顶部\1中间\2底部)
+ (void)translucentYESShowMessageWithView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName offsetType:(NSInteger)offsetType HideAfter:(NSTimeInterval)time;

#pragma mark - NSUserDefaults信息的 存储、获取、删除
+ (void)saveInfoObject:(id)object forKey:(NSString *)key;

+ (id)getInfoObjectForKey:(NSString *)key;

+ (void)removeInfoObjectForKey:(NSString *)key;

#pragma mark - 图片相关
//图片处理
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

+ (UIImage*)imageCompressWithSimple:(UIImage*)image;

+ (NSData *)newCompressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

+ (UIImage*)newImageCompressWithSimple:(UIImage*)image;

#pragma mark - 字符串相关
//根据字符串长度获取对应的宽度或者高度
+ (CGFloat)stringText:(NSString *)text font:(CGFloat)font isHeightFixed:(BOOL)isHeightFixed fixedValue:(CGFloat)fixedValue;

//字典转json格式字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

//可以删除nsstring中的数字、符号，或者修改其中的字符
+ (NSString *)stringDeleteString:(NSString *)str;

//计算字符串 size
+ (CGSize)sizeWithString:(NSString *)string font:(CGFloat)font;

#pragma mark - 时间日期相关
//获取当前时间
+ (NSString *)getCurrentTime;

//日期格式处理方法
+ (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat;

//比较两个日期的大小
+ (int)compareDate:(NSString *)date01 withDate:(NSString *)date02;

#pragma mark - 校验相关

//判断字符串是否为空
+ (BOOL)isNullWithStr:(NSString *)str;

//判断字符串是否为空(包括空字符串)
+ (BOOL)isNullWithString:(NSString *)str;

//验证固定电话
+ (BOOL)isTelNum:(NSString *)telNum;

//验证邮编
+ (BOOL)isPostcode:(NSString *)postcode;

//正则匹配用户密码6-18位数字和字母组合
+ (BOOL)validatePSW:(NSString *)psw;

//正则匹验证码,6位的数字
+ (BOOL)validateCode:(NSString *)code;

//邮箱验证
+ (BOOL)validateEmail:(NSString *)email;

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile;

//验证身份证号
+ (BOOL)validateUserID:(NSString *)userID;

//判断是否为社会信用代码
+ (BOOL)isSocialCredit18Number:(NSString *)socialCreditNum;

+ (NSString*)isOrNoPasswordStyle:(NSString *)passWordName;

+ (NSString*)isOrNoUserNameStyle:(NSString *)userName;

//昵称格式是否正确
+ (BOOL)isUserNameWithStr:(NSString *)content;

//是否包含特殊字符
+ (BOOL)isHaveSpecialCharWithStr:(NSString *)content;

@end
