#!/bin/sh

# 配置尺寸数组  
imageSize=(20 29 40 60)

# 图片路径
imagePath=$1
# 输出保存路径
exportPath=$2

if [ ! -n "$1" ] ;then
    imagePath="icon1024.png"
fi

if [ ! -n "$2" ] ;then
    exportPath="."
fi

# 输入各个尺寸icon
iPhoneIconWithSize() {
iPhoneSize=`expr $1 \* 2`
sips -Z $iPhoneSize $imagePath --out ${exportPath}/AppIcon.appiconset/icon_$1x$1@2x.png
iPhoneSize=`expr $iPhoneSize \* 3`
iPhoneSize=`expr $iPhoneSize / 2`
sips -Z $iPhoneSize $imagePath --out ${exportPath}/AppIcon.appiconset/icon_$1x$1@3x.png
}

# 输出Contents.json
setContents() {

json="{  \"images\" : ["
arr=$1
for iPhoneSize in  ${arr[*]}
do
size="${iPhoneSize}x${iPhoneSize}"
# 添加2x
filename="icon_${size}@2x.png"
json2x="{
      \"size\" : \"$size\",
      \"idiom\" : \"iphone\",
      \"scale\" : \"2x\",
      \"filename\" : \"$filename\"
    },"
json="$json$json2x"
# 添加3x
filename="icon_${size}@3x.png"
json3x="{
      \"size\" : \"$size\",
      \"idiom\" : \"iphone\",
      \"scale\" : \"3x\",
      \"filename\" : \"$filename\"
    },"
json="$json$json3x"
done

json1024="{
      \"filename\" : \"icon_1024x1024.png\",
      \"idiom\" : \"ios-marketing\",
      \"scale\" : \"1x\",
      \"size\" : \"1024x1024\"
 }"
json="$json$json1024"
jsonEnd="],  \"info\" : { \"version\" : 1,  \"author\" : \"xcode\" } }"
json="$json$jsonEnd"

cat <<EOF >${exportPath}/AppIcon.appiconset/Contents.json

$json

EOF
}

mkdir ${exportPath}/AppIcon.appiconset

setContents  "${imageSize[*]}"

for iPhoneSize in  ${imageSize[*]}
do
iPhoneIconWithSize $iPhoneSize
done

sips -Z "1024" $imagePath --out ${exportPath}/AppIcon.appiconset/icon_1024x1024.png

#关于iPad尺寸图标可根据需求自行添加尺寸，自己修改^…^


