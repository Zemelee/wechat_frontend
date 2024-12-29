<template>
    <div class="search-friends">
        <div style="margin-bottom:10px;padding: 4px;">联系人</div>
        <div v-for="item in friendSearchResult" :key="item" class="search-item">
            <div style="display:flex;align-items:center;gap:10px">
                <img :src="item.avatar" style="height:40px">
                <div>{{ item.nickname }}</div>
            </div>
            <a-button size="small" v-if="item.isFriend" @click="handleChat(item)">发消息</a-button>
            <a-button size="small" v-else @click="addFriendSubmit(item.uid)">加好友</a-button>
        </div>

        <div style="margin-bottom:10px;padding: 4px;">群聊</div>
        <div v-for="item in groupSearchResult" :key="item" class="search-item">
            <div style="display:flex;align-items:center;gap:10px">
                <img :src="item.groupAvatar" style="height:40px">
                <div>{{ item.groupName }}</div>
            </div>
            <a-button size="small" @click="handleChat(item)">发消息</a-button>
        </div>

        <div style="margin-bottom:10px;padding: 4px;">消息记录</div>
        <div v-for="item in historySearchResult" :key="item" class="search-item">
            {{item}}
            <a-button size="small" @click="handleChat(item)">定位</a-button>
        </div>
    </div>
</template>

<script setup>
import { defineEmits } from "vue";
import { addFriend } from "@/request/api"
import { message } from "ant-design-vue";
import { myFriends, useUser } from '@/store/index'
import { useRouter } from "vue-router";
const router = useRouter()
const props = defineProps({
    friendSearchResult: {
        type: Array,
        required: true,
        default: () => ([])
    },
    groupSearchResult: {
        type: Array,
        required: true,
        default: () => ([])
    },
    historySearchResult: {
        type: Array,
        required: true,
        default: () => ([])
    },
    type: {
        type: String,
        default: "local" // local or net
    }
})
const uid = localStorage.getItem("uid")
const myFriendsStore = myFriends()
const useUserStore = useUser()
const history = JSON.parse(localStorage.getItem("history")) || {}
const emit = defineEmits(["closeDialog"]) //关闭搜索结果
const addFriendSubmit = async (receive_id) => {
    if (uid == receive_id) {
        message.info("不能添加自己为好友")
        return
    }
    const res = await addFriend(uid, receive_id)
    if (res.code === 200) {
        myFriendsStore.pushFriend(res.data)
        history[receive_id] = []
        emit("closeDialog") //添加成功，关闭搜索结果
        useUserStore.setSearchWord("") //清空搜索框
        message.success(res.msg)
        setTimeout(() => {
            router.push({ name: 'message', params: { uid: receive_id } })
        }, 500)
    } else {
        message.error(res.msg)
    }
}

const handleChat = (curItem) => {
    console.log(curItem)
    //新增聊天列表项
    let chatList = JSON.parse(localStorage.getItem('chatList')) || []
    if(curItem.uid){
        chatList = chatList.filter(item => item.uid != curItem.uid)
    }else{
        chatList = chatList.filter(item => item.uid != curItem.groupId)
    }
    chatList.push({ uid: curItem.uid ? curItem.uid : curItem.groupId, lastTime: new Date().getTime() })
    localStorage.setItem('chatList', JSON.stringify(chatList))
    //设置当前聊天对象
    useUserStore.setCurNickname(curItem.nickname)
    emit("closeDialog") // 关闭搜索结果
    router.push({ name: 'message', params: { uid: curItem.uid } })
}


</script>

<style scoped>
.search-friends {
    background-color: #f5f5f5;
    width: 30vw;
    position: fixed;
    left: 5vw;
    top: 5vh;
    border: 1px solid red;
}

.search-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 90%;
    margin: 0 auto;
    padding: 10px;
    border-bottom: 1px solid #ccc;
    line-height: 30px;
}
</style>