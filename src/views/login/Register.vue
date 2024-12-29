<template>
  <div>
    <a-form :rules="rules" :model="user" ref="ruleFormRef">
      <a-form-item label="邮箱" name="email">
        <a-input v-model:value="user.email" :disabled="disInput" placeholder="请输入邮箱"></a-input>
      </a-form-item>
      <a-form-item label="验证码" name="userCode">
        <a-input v-model:value="user.userCode" :disabled="disInput" placeholder="请输入验证码"></a-input>
      </a-form-item>
      <a-form-item>
        <a-button type="primary" @click="sendCode" :disabled="disCodeBtn">获取验证码</a-button>
        &nbsp;
        <a-button type="primary" @click="verifyUserCode" :disabled="verifyBtn">验证验证码</a-button>
      </a-form-item>
      <a-form-item label="密码" name="password">
        <a-input-password autocomplete="off" v-model:value="user.password" placeholder="请输入密码"></a-input-password>
      </a-form-item>
      <a-form-item>
        <a-button :disabled="disPwdItem" type="primary" @click="register(ruleFormRef)">注册</a-button>
      </a-form-item>

    </a-form>
  </div>
</template>

<script setup>
import { reactive, ref, watch, defineEmits } from 'vue';
import { getCode, checkCode, userRegister } from "@/request/api";
import { message } from 'ant-design-vue';
const user = reactive({
  email: "",
  password: "",
  userCode: ""
})
let disCodeBtn = ref(true)// 获取验证码按钮状态
let verifyBtn = ref(true)// 验证按钮状态
let disPwdItem = ref(true)//注册按钮状态
let disInput = ref(false) // 输入框状态
let ruleFormRef = ref(null); // 获取表单
watch(() => user.email, (newV, oldV) => {
  if (newV.length >= 7 && newV.length <= 40) {
    disCodeBtn.value = false  // 启用验证按钮
  } else {
    disCodeBtn.value = true
  }
}
)

watch(() => user.userCode, (newV, oldV) => {
  if (newV.length == 5) {
    verifyBtn.value = false
  } else {
    verifyBtn.value = true
  }
}
)

const validatePassword = (rule, value, callback) => {
  if (!/[A-Za-z]/.test(value) || !/[0-9]/.test(value)) {
    callback(new Error('密码必须包含至少一个字母和一个数字'));
  } else {
    callback();
  }
};

// 表单合法性验证
const rules = {
  email: [
    { required: true, message: '请输入账号', trigger: 'blur' },
    { type: 'email', message: '邮箱格式不正确', trigger: ['blur'] },
    { min: 7, max: 30, message: '账号长度在 7 到 30 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' },
    { validator: validatePassword, trigger: 'blur' }
  ],
  userCode: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    { min: 5, max: 5, message: '验证码长度为 5 个字符', trigger: 'blur' }
  ]
}
const sendCode = async () => {
  getCode(user.email)
    .then(res => {
      console.log(res)
      if (res.code == 200) {
        message.success("发送成功")
        disCodeBtn.value = true
        setTimeout(() => {
          disCodeBtn.value = false
        }, 30000)
      }else{
        message.error(res.msg)
      }
    }).catch(err => {
      console.log(err)
    })
}

const verifyUserCode = () => {

  checkCode(user.email, user.userCode).then(res => {
    if (res.code==200) {
      message.success("验证码正确")
      verifyBtn.value = true //禁用一系列按钮和输入框
      disPwdItem.value = false
      disInput.value = true
      disCodeBtn.value = true
    } else {
      message.error(res.msg)
    }
  }).catch(err => {
    message.error(err.response.data)
  })
}
const emit = defineEmits(['recvDialog'])

const register = async () => {
  try {
    await ruleFormRef.value.validate();
  } catch (error) {
    throw new Error('表单验证不通过');
  }
  if (!user.email || user.password.length <= 5 || !user.userCode) {
    message.error("请输入完整信息")
    return;
  }
  // 密码加密
  user.password = btoa(user.password)
  userRegister(user).then(res => {
    emit('recvDialog', res)
  })
  // .catch(err => {
    // message.error(err.response.data)
  // })
};



</script>

<style scoped>
form {
  display: flex;
  flex-direction: column;
  max-width: 300px;
  margin: 0 auto;
}
</style>
