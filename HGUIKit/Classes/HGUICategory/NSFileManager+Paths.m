//
//  NSFileManager+Paths.m
//  HGUIKit
//

#import "NSFileManager+Paths.h"
#import <YYKit/NSString+YYAdd.h>

@implementation NSFileManager (Paths)

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory {
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory {
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)documentsURL {
    return [self URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)documentsPath {
    return [self pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)libraryURL {
    return [self URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)libraryPath {
    return [self pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)cachesURL {
    return [self URLForDirectory:NSCachesDirectory];
}

+ (NSString *)cachesPath {
    return [self pathForDirectory:NSCachesDirectory];
}

+ (NSString *)getFileDocumentPath:(NSString *)fileName
{
    if (nil == fileName)
    {
        return nil;
    }
    NSString *documentDirectory = [NSFileManager documentsPath];
    NSString *fileFullPath = [documentDirectory stringByAppendingPathComponent:fileName];
    return fileFullPath;
}

+ (NSString *)getFileCachePath:(NSString *)fileName
{
    if (nil == fileName)
    {
        return nil;
    }
    NSString *cacheDirectory = [NSFileManager cachesPath];
    NSString *fileFullPath = [cacheDirectory stringByAppendingPathComponent:fileName];
    return fileFullPath;
}

+ (NSString *)getFileResourcePath:(NSString *)fileName
{
    if (!fileName.isNotBlank)
    {
        return nil;
    }
    // 获取资源目录路径
    NSString *resourceDir = [[NSBundle mainBundle] resourcePath];
    return [resourceDir stringByAppendingPathComponent:fileName];
}

+ (BOOL)isExistFileInDocument:(NSString *)fileName
{
    if (!fileName.isNotBlank)
    {
        return NO;
    }
    
    NSString *filePath = [NSFileManager getFileDocumentPath:fileName];
    if (nil == filePath)
    {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL)isExistFileInCache:(NSString *)fileName
{
    if (nil == fileName || [fileName length] == 0)
    {
        return NO;
    }
    NSString *filePath = [NSFileManager getFileCachePath:fileName];
    if (nil == filePath)
    {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL)removeFolderInDocumet:(NSString *)aFolderNameInDoc
{
    if (!aFolderNameInDoc.isNotBlank)
    {
        return YES ;
    }
    NSString *filePath = [NSFileManager getFileDocumentPath:aFolderNameInDoc];
    if (nil == filePath)
    {
        return YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}

+ (BOOL)removeFolderInCahe:(NSString *)aFolderNameInCahe
{
    if (!aFolderNameInCahe.isNotBlank)
    {
        return YES ;
    }
    
    if (![NSFileManager isExistFileInCache:aFolderNameInCahe]) {
        return YES;
    }
    
    NSString *filePath = [NSFileManager getFileCachePath:aFolderNameInCahe];
    if (nil == filePath)
    {
        return YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}

// 判断一个文件是否存在于resource目录下
+ (BOOL)isExistFileInResource:(NSString *)fileName
{
    if (!fileName.isNotBlank)
    {
        return NO;
    }
    NSString *filePath = [NSFileManager getFileResourcePath:fileName];
    if (nil == filePath)
    {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL)isExistFile:(NSString *)aFilePath
{
    if (!aFilePath.isNotBlank)
    {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:aFilePath];
}

+ (BOOL)copyResourceFileToDocumentPath:(NSString *)resourceName
{
    if (!resourceName.isNotBlank)
    {
        return NO;
    }
    //获取资源文件的存放目录进行
    NSString *resourcePath = [NSFileManager getFileResourcePath:resourceName];
    NSString *documentPath = [NSFileManager getFileDocumentPath:resourceName];
    if (nil == resourcePath || nil == documentPath)
    {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([NSFileManager isExistFile:documentPath])
    {
        // 如果文件已存在， 那么先删除原来的
        [NSFileManager deleteFileAtPath:documentPath];
    }
    
    BOOL succ = [fileManager copyItemAtPath:resourcePath toPath:documentPath error:nil];
    return succ;
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath
{
    if (!filePath.isNotBlank)
    {
        return NO;
    }
    // 判断文件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        return [fileManager removeItemAtPath:filePath error:nil];
    }
    return NO;
}

+ (NSDictionary *)getFileAttributsAtPath:(NSString *)filePath
{
    if (!filePath.isNotBlank)
    {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath] == NO)
    {
        return nil;
    }
    return [fileManager attributesOfItemAtPath:filePath error:nil];
}

+ (BOOL)createDirectoryAtDocument:(NSString *)dirName
{
    if (nil == dirName)
    {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [NSFileManager getFileDocumentPath:dirName];
    if ([fileManager fileExistsAtPath:dirPath])
    {
        return YES;
    }
    
    BOOL succ = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    return succ;
}

+ (BOOL)createDirectoryAtCache:(NSString *)dirName
{
    if (nil == dirName)
    {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [NSFileManager getFileCachePath:dirName];
    if ([fileManager fileExistsAtPath:dirPath])
    {
        return YES;
    }
    
    BOOL succ = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    return succ;
}

+ (long long)getFreeSpaceOfDisk
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *freeSpace = [fattributes objectForKey:NSFileSystemFreeSize];
    long long space = [freeSpace longLongValue];
    return space;
}

+ (long long)getFileSize:(NSString *)filePath
{
    NSDictionary *fileAttributes = [self getFileAttributsAtPath:filePath];
    if (fileAttributes)
    {
        NSNumber *fileSize = (NSNumber*)[fileAttributes objectForKey: NSFileSize];
        if (fileSize)
        {
            return [fileSize longLongValue];
        }
    }
    return 0;
}

+ (BOOL)copySourceFile:(NSString *)sourceFile toDesPath:(NSString *)desPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 读取文件的信息
    NSData *sourceData = [NSData dataWithContentsOfFile:sourceFile];
    BOOL e = NO;
    if (sourceData)
    {
        e = [fileManager createFileAtPath:desPath contents:sourceData attributes:nil];
    }
    //    NSError *error = nil;
    //    BOOL e =  [fileManager copyItemAtPath:sourceFile toPath:desPath error:&error];
    return YES;
}

+ (BOOL)moveSourceFile:(NSString *)sourceFile toDesPath:(NSString *)desPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager moveItemAtPath:sourceFile toPath:desPath error:&error];
    if (error)
    {
        return NO;
    }
    return YES;
}

// 如果应用程序覆盖安装后，其document目录会发生变化，该函数用于替换就的document路径
+ (NSString *)reCorrentPathWithPath:(NSString *)path
{
    if (nil == path)
    {
        return nil;
    }
    NSString *docPath = [NSFileManager documentsPath];
    NSRange range = [path rangeOfString:docPath];
    // 没找到正确的document路径
    if (range.length <= 0)
    {
        NSRange docRange = [path rangeOfString:@"Documents/"];
        if (docRange.length > 0)
        {
            NSString *relPath = [path substringFromIndex:docRange.location + docRange.length];
            NSString *newPath = [NSFileManager getFileDocumentPath:relPath];
            return newPath;
        }
    }
    return path;
}

+ (NSUInteger)folderSize:(NSString *)folderPath
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSArray *filesArray = [mgr subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    NSUInteger fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [mgr attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

@end
