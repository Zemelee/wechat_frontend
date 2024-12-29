<template>
  <div class="chat-container">
    <div class="friend-list">
      <div v-for="(item, index) in groupList" :key="index" class="friend-item" @click="HandleClick(item)"
        @mouseenter="() => { hoveredIndex = index }" @mouseleave="() => { hoveredIndex = null }">
        <img :src="item.groupAvatar" alt="group_avator" class="group-avator">
        <span class="group-name">{{ item.groupName }}</span>
        <a-button type="link" danger style="font-size: small;" v-show="hoveredIndex === index && item.creatorId == uid"
          @click="delGroupSubmit(item.groupId)">解散</a-button>
        <a-button type="link" danger style="font-size: small;" v-show="hoveredIndex === index && item.creatorId != uid"
          @click="removeMe(item.groupName, item.groupId)">退群</a-button>
      </div>
    </div>
    <div class="chat-content">
      <div class="chat-history" ref="chatHistory">
        <div v-for="item in useWs.curHistory.value" :key="item.id" class="message-bubble">
          <SingleMsg :message="item.content" :avatar="item.avatar" :nickname="item.nickname" :time="item.send_at"
            :isSelf="item.isSelf" @delete="deleteMsg(item)" @back="backMsg(item)" />
        </div>
      </div>
      <div class="chat-input" v-show="curGid">
        <a-textarea v-model:value="currentMsg" @keyup.enter.prevent="sendMsg" placeholder="输入聊天消息..." :rows="4"
          class="textarea" />
        <div style="text-align: center;margin-top: 10px;">
          <a-popover placement="topRight">
            <template #content>
              <div class="emoji-items">
                <span style="margin: 5px; cursor: pointer;" class="emoji" v-for="item in emojis" :key="item"
                  @click="() => { currentMsg += item }">{{ item
                  }}</span>
              </div>
            </template>
            <UpSquareTwoTone />
          </a-popover>
          <PlusSquareTwoTone style="margin: 5px; cursor: pointer;" @click="newJoinModal = !newJoinModal" />
          <br>
          <br>
          <a-button @click="sendMsg" :disabled="currentMsg.length <= 0" type="primary">发送</a-button>
        </div>
      </div>
    </div>
  </div>
  <div class="new-group" v-show="newJoinModal">
    <NewJoin :gid="curGid" @close="() => { newJoinModal = !newJoinModal }"></NewJoin>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch, nextTick, toRaw } from "vue";
import { UpSquareTwoTone, PlusSquareTwoTone } from '@ant-design/icons-vue';
import { useRoute } from "vue-router";
import { message, Modal } from "ant-design-vue";
import { getMsgs, addGroup, joinGroup, delGroup, delGroupUser } from '@/request/api'
import { useWsStore } from '@/store/wsStore'
import { storeToRefs } from 'pinia';
import { useUser } from '@/store/index';
import SingleMsg from './SingleMsg'
import NewJoin from '@/components/NewJoin'

const router = useRoute();
const wsStore = useWsStore();
const userStore = useUser()
const useUserStore = storeToRefs(userStore)
const useWs = storeToRefs(wsStore);
let uid = localStorage.getItem('uid')
let histories;
let curGid = ref(useWs.gid.value);
let groupList = JSON.parse(localStorage.getItem('groupList')) || [];
let newJoinModal = ref(false)

watch(() => useWs.gid.value, async () => {
  curGid.value = useWs.gid.value;
  try {
    const GidMsgs = await getMsgs({ uid: Number(uid), groupId: curGid.value });
    GidMsgs.forEach(item => {
      item.isSelf = item.uid == uid;
      item.nickname = item.senderNickname;
      item.avatar = item.senderAvatar;
      item.send_at = item.send_at;
    });
    wsStore.setCurHistory(GidMsgs);
  } catch (error) {
    console.error('获取历史记录失败，调用本地记录:', error);
  }
});
let chatList = JSON.parse(localStorage.getItem('chatList')) || [] //聊天列表，存uid和时间
let chatIds = chatList.map(item => item.uid)

onMounted(() => {
  histories = JSON.parse(localStorage.getItem('histories')) || {}
  if (!useWs.ws) wsStore.connectWs(uid)
  if (router.params.gid) {
    wsStore.setCurGid(router.params.gid)
  }
})

//卸载时
onUnmounted(() => {
  wsStore.setCurGid(0);
  userStore.setCurNickname("");
})
//悬浮显示
const hoveredIndex = ref(null)

//将uid传给父组件
const HandleClick = (groupItem) => {
  wsStore.setCurGid(groupItem.groupId); //设置当前聊天对象
  userStore.setCurNickname(groupItem.groupName);
}

const delGroupSubmit = (gid) => {
  Modal.confirm({
    title: `确认删除群聊 ${gid} 吗?`,
    okText: '确认',
    cancelText: '取消',
    onOk() {
      delGroup(gid).then(e => {
        if (e.code == 200) {
          groupList = groupList.filter(item => item.groupId !== gid)
          localStorage.setItem('groupList', JSON.stringify(groupList))
          message.success('删除群聊成功')
          wsStore.setCurGid(groupList[0].groupId)
          //删除聊天记录
          delete histories[gid];
          localStorage.setItem('histories', JSON.stringify(histories))
        }
      })
    },
    onCancel() {
      console.log('Cancel');
    }
  });

}

const removeMe = (gname, gid) => {
  Modal.confirm({
    title: `确认退出群聊 ${gname} 吗?`,
    okText: '确认',
    cancelText: '取消',
    onOk() {
      delGroupUser(gid, [uid]).then(e => {
        if (e.code == 200) {
          message.success('退群成功')
          groupList = groupList.filter(item => item.groupId !== gid)
          localStorage.setItem('groupList', JSON.stringify(groupList))
          delete histories[gid];
          localStorage.setItem('histories', JSON.stringify(histories))
        } else {
          message.error('退群失败')
        }
      })
    },
    onCancel() {
      console.log('Cancel');
    }
  });

}

const deleteMsg = (e) => {
  // 调用接口删除
  const index = histories[curGid.value].findIndex(item => item.content == e.content)
  if (index !== -1) {
    wsStore.spliceCurHistory(index)
  }
  localStorage.setItem('histories', JSON.stringify(histories))
}

//撤回消息
const backMsg = async (e) => {
  let backMsg = toRaw(e)
  console.log(backMsg)
  let newMsg = {
    back: 1, //撤回字段
    mid: backMsg.mid,
    groupId: backMsg.groupId,
    uid: backMsg.uid,
    content: backMsg.content,
    send_at: backMsg.send_at
  };
  try {
    await wsStore.wsSend(newMsg);
    // 更新UI
    const GidMsgs = await getMsgs({ uid: Number(uid), groupId: curGid.value });
    GidMsgs.forEach(item => {
      item.isSelf = item.uid == uid;
      item.nickname = item.senderNickname;
      item.avatar = item.senderAvatar;
      item.send_at = item.sendAt;
      item.hasBack = item.back == 1; //等于1表示撤回
    });
    wsStore.setCurHistory(GidMsgs);
  } catch (error) {
    console.error("消息发送失败:", error);
  }
}


let currentMsg = ref("")
const sendMsg = async (event) => {
  event.preventDefault()
  let newMsg = {
    back: 0,
    groupId: curGid.value,
    uid: uid,
    content: currentMsg.value,
    send_at: new Date().toISOString()
  };
  try {
    // 等待 wsSend 完成
    await wsStore.wsSend(newMsg);
    // 给 newMsg 设置发送者昵称和头像(我)
    newMsg.nickname = useUserStore.userInfo.value.nickname;
    newMsg.avatar = useUserStore.userInfo.value.avatar;
    newMsg.isSelf = true;
    // 更新当前好友聊天记录
    wsStore.pushCurHistory(newMsg)
    histories = JSON.parse(localStorage.getItem('histories'))
    // 滚动到底部
    scrollToBottom();
    // 清空输入框
    currentMsg.value = "";
  } catch (error) {
    // 处理发送失败的情况
    console.error("消息发送失败:", error);
  }
}

let chatHistory = ref(null)
const scrollToBottom = async () => {
  if (chatHistory.value) {
    await nextTick(); // 等待 DOM 更新
    chatHistory.value.scrollTop = chatHistory.value.scrollHeight;
    console.log(chatHistory.value.scrollTop, chatHistory.value.scrollHeight);
  }
};
let emojis = ["🥰", "🥳", "🥺", "🥵", "🥴", "🥶", "🧐", "🤪", "🤫", "🤬",
  "🤭", "🤮", "🤯", "🤨", "🤩", "🤣", "🤤", "🤢", "🤧", "🤠", "🤥", "😳",
  "😊", "😘", "😡", "😭", "😈", "🤡", "💩", "👉", "👈"]

</script>

<style scoped>
.chat-container {
  display: flex;
  height: 100%;
  border: 1px solid blue;
}

.friend-list {
  background-color: #f8f8f8;
  padding: 10px;
  width: 20vw;
  height: 100%;
  border: 1px solid red;
}

.friend-item {
  cursor: pointer;
  display: flex;
  align-items: center;
  padding: 10px;
  border-bottom: 1px solid #c1c1c1;
}

.friend-item:hover {
  background-color: #e6e6e6;
}

.group-avator {
  width: 30px;
  height: 30px;
  border-radius: 4px;
  margin-right: 40px;
}


.group-name {
  font-size: 16px;
  color: #333;
  line-height: 1.8;
  width: 100px;
}

.chat-content {
  height: 100%;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.chat-history {
  flex: 1;
  padding: 10px;
  overflow-y: auto;
  background-color: #f5f5f5;
}

.message-bubble {
  margin-bottom: 10px;
}


.chat-input {
  display: flex;
  padding: 10px;
  border-top: 1px solid #e6e6e6;
}

.textarea {
  flex: 1;
  margin-right: 10px;
  resize: none;
  border-radius: 4px;
  border: 1px solid #d9d9d9;
}

.chat-history::-webkit-scrollbar {
  width: 8px;
}

.chat-history::-webkit-scrollbar-thumb {
  background-color: #ccc;
  border-radius: 4px;
}

.chat-history::-webkit-scrollbar-thumb:hover {
  background-color: #b3b3b3;
}

.emoji-items {
  width: 300px;
}

.emoji :hover {
  cursor: pointer;
  color: #1890ff;
  transition: color 0.3s ease;
}

.new-group {
  position: absolute;
  top: 40%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 38vw;
  /* height: 60vh; */
  background-color: #efecec;
  border-radius: 20px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}
</style>