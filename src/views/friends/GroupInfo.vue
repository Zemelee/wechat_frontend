<template>
    <div style="margin:40px 0 0 150px;flex:1;align-items: center;justify-content: center;">
        <div class="header">
            <img :src="props.curGroup?.groupAvatar">
            <div style="margin:15px 0 0 10px">
                <p class="info-item">群名: {{ props.curGroup?.groupName }}</p>
            </div>
        </div>
        <div>
        </div>
        <a-divider></a-divider>
        <div style="display:flex; gap:10px;">
            <div @click="handleChat" class="handle-btn">
                <WechatOutlined :style="{ fontSize: '25px', color: '#576b95' }" />
                <br>
                <span>消息聊天</span>
            </div>
            <div @click="handleDelete(props.curGroup)" class="handle-btn" v-if="props.curGroup?.creatorId == uid">
                <DeleteOutlined :style="{ fontSize: '25px', color: '#576b95' }" />
                <br>
                <span>删除群聊</span>
            </div>
        </div>
    </div>

</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from 'vue-router'
import { useUser } from '@/store/index'
import { message, Modal } from 'ant-design-vue'
import { WechatOutlined, DeleteOutlined } from '@ant-design/icons-vue'
const router = useRouter()
const useUserStore = useUser()
const props = defineProps({
    curGroup: {
        type: Object,
        default: () => ({}),
    },
})
let uid = localStorage.getItem('uid')
const handleChat = () => {
    //新增聊天列表项
    let chatList = JSON.parse(localStorage.getItem('chatList')) || []
    chatList = chatList.filter(item => item.uid != props.curGroup.uid)
    chatList.push({ uid: props.curGroup.uid, lastTime: new Date().getTime() })
    localStorage.setItem('chatList', JSON.stringify(chatList))
    //设置当前聊天对象
    useUserStore.setCurNickname(props.curGroup.groupName)
    router.push({ name: 'group', params: { gid: Number(props.curGroup.groupId) } })
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