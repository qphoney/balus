#!/bin/sh

# シータの存在を確認
if [ ! -x ./sheeta.sh ] ; then
  echo "見せてあげよう、ラピュタの雷を！！"
  exit 1
fi

# パズーの存在を確認
if [ ! -x ./pazu.sh ] ; then
  echo "見ろ！人がゴミのようだ！！"
  exit 2
fi

# ムスカ大佐の存在を確認
if [ ! -x ./muska.sh ] ; then
  echo "小僧！！娘の命と引き換えだ！！石のありかを言え！！"
  exit 3
fi

# Levistone(飛行石)の存在を確認
if [ ! -f ./levistone ] ; then
  echo "それともその大砲で私と勝負するかね！？"
  exit 4
fi

# 出演者のセリフ
. ./sheeta.sh
. ./pazu.sh
. ./muska.sh
. ./sheeta-pazu-muska.sh

# 役者が揃ったのでバルス発動
echo "ムスカ：時間だ！答えを聞こう！！"
sleep 5
jp2a --color ./pics/sheeta-pazu1.jpg
sleep 5
echo "ムスカ：・・んん？"
jp2a -i ./pics/balus1.jpg
sleep 5

# 削除対象の取得
i=$(ec2-describe-instances | grep instance | awk '{print $3}')
si=$(ec2-describe-spot-instance-requests | grep SPOTINSTANCEREQUEST | grep active |awk '{print $8}')
as=$(as-describe-auto-scaling-groups | grep AUTO-SCALING-GROUP | awk '{print $2}')

# 問答無用でAutoScalingGroupを削除
for autoscale in $as ; do
  yes | as-delete-auto-scaling-group $autoscale --force-delete
done

for ondemand in $i ; do
  # termination protectionが有効になっていたら外す
  if [ `ec2-describe-instance-attribute --disable-api-termination $ondemand | awk '{print $3}'` = true ] ; then
    ec2-modify-instance-attribute $ondemand --disable-api-termination false
  fi
  # 削除しちゃうよ
  ec2-terminate-instances $ondemand
done

# スポットインスタンスを削除
for spot in $si ; do
  ec2-terminate-instances $spot
done

# 目がぁぁぁぁっぁぁ
jp2a --color ./pics/muska2.jpg
echo 目がぁぁぁぁっぁぁ!!目がぁぁぁぁっぁぁ!!!!!
sleep 10

# ラピュタ崩れる
jp2a --color ./pics/break-laputa.jpg
sleep 10

# ラピュタ飛んでいく
jp2a --color ./pics/laputa-fly.jpg
sleep 10

# 見つめるシータとパズー
jp2a --color ./pics/after-balus.jpg
sleep 10

# エンディング
jp2a -i ./pics/end.jpg
sleep 5
