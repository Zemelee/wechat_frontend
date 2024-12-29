<template>
    <textarea ref="textCopy" style="position: fixed;left: -1000px;height: -1000px;"></textarea>
    <div v-if="!props.hasBack" class="message-item" :class="{ 'self-message': isSelfMessage }"
        @mouseenter="showTime = true" @mouseleave="showTime = false">
        <img class="avatar" :src="props.avatar" alt="avatar" />
        <div @contextmenu.prevent="openContextMenu($event)">
            <div class="nick-name">{{ props.nickname }} <span v-show="showTime"> | {{ formatTime(props.time) }}</span>
            </div>
            <div class="content">
                <div class="message">{{ props.message }}</div>
                <div class="message" style="border-top: 1px solid #ccc; padding-top: 3px" v-if="translateText">{{
                    translateText }}</div>
            </div>
        </div>
        <div v-if="showContextMenu" :style="menuStyle" class="context-menu">
            <ul>
                <li @click="menuAction('Copy')">复制</li>
                <li @click="menuAction('Translate')">翻译</li>
                <li @click="menuAction('Delete')">删除</li>
                <li v-if="isSelf" @click="menuAction('Back')">撤回</li>
            </ul>
        </div>
    </div>
    <div v-else="" class="back-msg">
        <div class="back-msg-span">撤回了一条消息</div>
    </div>
</template>

<script setup>
import { computed, ref, onMounted, onUnmounted, defineEmits } from 'vue'
import { message } from 'ant-design-vue'
import { formatTime } from '@/utils/index'
import { translate } from '@/request/api'
const props = defineProps({
    avatar: {
        type: String,
        default: "http://example.com/default-avatar.png",
    },
    nickname: {
        type: String,
        default: "Unknown",
    },
    message: {
        type: String,
        default: "Unknown",
    },
    time: {
        type: String,
        default: "Unknown",
    },
    isSelf: {
        type: Boolean,
        default: false,
    },
    hasBack: {
        type: Boolean,
        default: false
    },
});


const isSelfMessage = computed(() => props.isSelf);
const showTime = ref(false);
const showContextMenu = ref(false);
const menuPosition = ref({ x: 0, y: 0 });
const menuStyle = computed(() => ({
    position: 'fixed',
    left: `${menuPosition.value.x}px`,
    top: `${menuPosition.value.y}px`
}));

const openContextMenu = (event) => {
    menuPosition.value.x = event.clientX;
    menuPosition.value.y = event.clientY;
    showContextMenu.value = true;
};
let textCopy = ref(null)
const emit = defineEmits(['delete', 'back'])

let translateText = ref("")
const menuAction = (action) => {
    if (action === 'Copy') {
        textCopy.value.value = props.message;
        textCopy.value.focus()
        textCopy.value.select()
        if (!document.execCommand('copy')) {
            message.error("此网站在此浏览器上不可复制")
        }
        message.success("复制成功", 1)
    } else if (action === "Translate") {
        translate(props.message).then(res => {
            translateText.value = res.trans_result[0].dst
        })
    } else if (action === 'Delete') {
        emit("delete", props)
    } else if (action === 'Back') {
        emit("back", props)
    }
    showContextMenu.value = false;
};

// 监听页面点击事件，用于关闭右键菜单
const closeContextMenu = () => {
    showContextMenu.value = false;
};

// 组件挂载后添加全局点击事件监听
onMounted(() => {
    window.addEventListener('click', closeContextMenu);
});

// 组件卸载前移除事件监听
onUnmounted(() => {
    window.removeEventListener('click', closeContextMenu);
});
</script>

<style scoped>
.message-item {
    display: flex;
    align-items: flex-start;
    margin-bottom: 15px;
    max-width: 100%;
    min-height: 60px;
}

.avatar {
    width: 40px;
    height: 40px;
    border-radius: 10%;
    margin-right: 10px;
    margin-left: 10px;
}

.content {
    background-color: #fff;
    color: black;
    padding: 10px;
    border-radius: 5px;
    position: relative;
}

.nick-name {
    font-size: 10px;
    color: #333;
    margin-bottom: 5px;
}

.message {
    font-size: 16px;
    word-wrap: break-word;
    white-space: pre-wrap;
}

.time {
    position: absolute;
}

.self-message {
    flex-direction: row-reverse;
}

.self-message .avatar {
    margin-left: 10px;
    margin-right: 0;
}

.self-message .content {
    background-color: #07c160;
    color: black;
}

.self-message .time {
    right: initial;
    left: 10px;
}

.self-message .nick-name {
    text-align: right;
}

.context-menu {
    background-color: #fff;
    border: 1px solid #ccc;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5);
    z-index: 1000;
    padding: 5px;
}

.context-menu ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.context-menu ul li {
    padding: 8px 12px;
    cursor: pointer;
}

.context-menu ul li:hover {
    background-color: #f0f0f0;
}

.back-msg {
    background-color: #f0f0f0;
    border-radius: 5px;
    padding: 5px;
    margin: 5px 6px 6px 155px;
    width: 70%;
    display: inline-block;
    text-align: left;
    word-wrap: break-word;
    word-break: break-all;
}
.back-msg-span{
    text-align: center;
}

</style>