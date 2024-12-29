<template>
  <div style="margin:40px 0 0 150px;flex:1;align-items: center;justify-content: center;">
    <div class="header">
      <img :src="props.curFriend?.avatar">
      <div style="margin:15px 0 0 10px">
        <p class="info-item">昵称：{{ props.curFriend?.nickname }}</p>
        <p class="info-item">邮箱：{{ props.curFriend?.email }}</p>
        <p class="info-item">地址：{{ props.curFriend?.address }}</p>
      </div>
    </div>
    <div>
      <span style="color:#9e9e9e;font-size:15px;margin-right: 20px">个性签名</span> {{ props.curFriend?.sign }}
    </div>
    <a-divider></a-divider>
    <div style="display:flex;gap:10px;">
      <div @click="handleChat" class="handle-btn">
        <WechatOutlined :style="{ fontSize: '25px', color: '#576b95' }" />
        <br>
        <span>消息聊天</span>
      </div>
      <div @click="handleDelete(props.curFriend)" class="handle-btn">
        <DeleteOutlined :style="{ fontSize: '25px', color: '#576b95' }" />
        <br>
        <span>删除好友</span>
      </div>
    </div>
  </div>

</template>

<script setup>
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia';
import { myFriends, useUser } from '@/store/index'
import { delFriend } from '@/request/api'
import { message, Modal } from 'ant-design-vue'
import { WechatOutlined, DeleteOutlined } from '@ant-design/icons-vue'
const friendStore = myFriends()
const useUserStore = useUser()
const useFriendStore = storeToRefs(friendStore)
const router = useRouter()
const props = defineProps({
  curFriend: {
    type: Object,
    default: () => ({}),
  },
})

const handleChat = () => {
  //新增聊天列表项
  let chatList = JSON.parse(localStorage.getItem('chatList')) || []
  chatList = chatList.filter(item => item.uid != props.curFriend.uid)
  chatList.push({ uid: props.curFriend.uid, lastTime: new Date().getTime() })
  localStorage.setItem('chatList', JSON.stringify(chatList))
  //设置当前聊天对象
  useUserStore.setCurNickname(props.curFriend.nickname)
  router.push({ name: 'message', params: { uid: props.curFriend.uid } })
}
const uid = localStorage.getItem('uid')
const handleDelete = (curFriend) => {
  Modal.confirm({
    title: `确认删除好友 ${curFriend.nickname} 吗?`,
    okText: '确认',
    cancelText: '取消',
    onOk() {
      delFriend(uid, curFriend.uid).then(e => {
        if (e.code == 200) {
          //还需要删除与之对应的聊天记录
          let newList = useFriendStore.friends.value.filter(friend => friend.uid != curFriend.uid)
          friendStore.setFriends(newList) // 更新响应式好友列表
          // 从消息列表中剔除
          let chatList = JSON.parse(localStorage.getItem("chatList"))
          chatList = chatList.filter(item => item.uid != curFriend.uid)
          localStorage.setItem("chatList", JSON.stringify(chatList))
          message.success('删除成功')
        }
      })
    },
    onCancel() {
      console.log('Cancel');
    }
  });

}

</script>

<style scoped>
.header {
  display: flex;
  border: 1px saddlebrown red;
}

.info-item {
  color: #9e9e9e;
  font-size: 12px;
}

img {
  width: 80px;
  height: 80px;
  border-radius: 50%;
}

.handle-btn {
  margin-left: 20px;
  display: inline-block;
  width: 80px;
  height: 60px;
  text-align: center;
  cursor: pointer;
  padding-top: 10px;
}

.handle-btn:hover {
  background-color: #eee;
}
</style>