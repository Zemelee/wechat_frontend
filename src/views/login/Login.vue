<template>
    <div class="outLogin">
        <div class="login">
            <h3>仿微信聊天系统</h3>
            <a-form ref="formRef" :rules="rules" :model="user" autocomplete="off" @finish="onFinish"
                @finishFailed="onFinishFailed">
                <a-form-item label="邮箱" name="account">
                    <a-input v-model:value="user.account" placeholder="邮箱账户"></a-input>
                </a-form-item>
                <a-form-item label="密码" name="password">
                    <a-input-password v-model:value="user.password" placeholder="密码" type="password"></a-input-password>
                </a-form-item>
                <a-form-item>
                    <a-button type="primary" @click="login">登录</a-button> &nbsp;
                    <a-button type="primary" @click="register">注册</a-button>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="https://gitee.com/organizations/num_5" target="_blank"><span>by num_5</span></a>
                </a-form-item>
            </a-form>
        </div>
    </div>
    <a-modal title="新用户注册" ref="dialogRef" v-model:open="showDialog">
        <br />
        <Dialog @recvDialog="handleLoginMsg" />
    </a-modal>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import Dialog from "./Register.vue";
import { useRouter } from "vue-router";
import { message } from 'ant-design-vue';
import { userLogin } from "@/request/api";
import { useUser } from "@/store/index";
const useUserStore = useUser();
const router = useRouter();
onMounted(() => {
    //清除所有缓存
    // localStorage.clear();
});
// 定义账户和密码
let user = reactive({ account: "", password: "" });
const formRef = ref(null);
const login = async () => {
    formRef.value
        .validate()
        .then(e => {
            userLogin({ email: user.account, password: btoa(user.password) }).then(e => {
                if (e.code == 200) {
                    localStorage.setItem('uid', e.data.uid)
                    localStorage.setItem('userinfo', JSON.stringify(e.data))
                    useUserStore.setUserInfo(e.data)

                    router.push('/home')
                } else {
                    message.error(e.msg)
                }
            })
        })
        .catch(error => {
            message.error("未知错误")
        });
}

const rules = reactive({
    account: [
        { required: true, message: "请输入账户", trigger: "blur" },
        { type: "email", message: "请输入正确的邮箱地址", trigger: ["blur"] },
        { min: 10, max: 30, message: '账号长度在 11 到 30 个字符', trigger: 'blur' }
    ],
    password: [
        { required: true, message: "请输入密码", trigger: "blur" },
        { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
    ],
})
const onFinish = (values) => {
    console.log('Success:', values);
};

const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
};

const showDialog = ref(false);
const register = () => {
    showDialog.value = true;
};

const handleLoginMsg = (res) => {
    if (res.code == 200) {
        message.success(res.msg)
    } else {
        message.error(res.msg)
    }
    showDialog.value = false;
};


</script>


<style scoped>
.login {
    width: 400px;
    margin: 100px auto;
    padding: 20px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    background-color: #fff;
    border-radius: 10px;
}

.outLogin {
    background-size: cover;
    height: 100vh;
    width: 100vw;
    padding: 20px;
    z-index: -1;
}
</style>