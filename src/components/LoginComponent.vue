<script setup>
import {ref, defineEmits} from "vue";
import axios from "axios";
import {useToast} from "vue-toast-notification";
const emit = defineEmits(["user-logged-in", "close-login-widget"]);
const password = ref("");
const email = ref("");
const token = ref("");
const firstname = ref("");
const lastname = ref("");

const $toast = useToast();

function login() {
  let formdata = new FormData();
  formdata.append("email", email.value);
  formdata.append("password", password.value);
  axios(
    {
      method: "post",
      url: "http://host.docker.internal:10001/auth/login",
      data: formdata,
    }
  ).then((res) => {
    console.log(res.data)
    token.value = res.data.token;
    // Save token to local storage
    localStorage.setItem("token", res.data.token);
    localStorage.setItem("user_id", res.data.user_id);
    // emit logged in event
    emit("user-logged-in");
    emit("close-login-widget");
    $toast.success("Logged in as " + res.data.user_id);
  }).catch((err) => {
    console.log(err);
  })
}

function register() {
  let formdata = new FormData();
  formdata.append("firstname", firstname.value);
  formdata.append("lastname", lastname.value);
  formdata.append("email", email.value);
  formdata.append("password", password.value);
  axios(
      {
        method: "post",
        url: "http://host.docker.internal:10001/user",
        data: formdata
      }
  ).then((res)=> {
    token.value = res.data;
    // save userid to local storage
    if (res.data.user_id) {
      localStorage.setItem("user_id", res.data.user_id);
    }
    $toast.success("Registered user " + res.data.user_id);
    // instantly obtain a token for the newly created user
    login();
  }).catch((err) => {
    console.log(err);
  });
}
const loginform = ref(false);
</script>

<template>
  <div class="w-screen h-screen flex justify-center items-center fixed top-0 left-0 z-40">
    <div class="w-1/2 flex flex-col">
      <div class="flex items-center justify-evenly w-full bg-slate-700 text-white">
        <h2 class="p-5 w-full text-center" :class="{ 'bg-slate-800': loginform }" @click="loginform = true">Login</h2>
        <h2 class="p-5 w-full text-center" :class="{ 'bg-slate-800': !loginform }" @click="loginform = false">Register</h2>
      </div>
      <!-- Login -->
      <div v-if="loginform" class="bg-slate-800 text-white w-full h-full text-center p-10 flex flex-col justify-center items-center gap-5">
        <h1 class="text-3xl font-bold">Login</h1>
        <input class="w-1/2 text-black p-3" placeholder="email" v-model="email"/>
        <input class="w-1/2 text-black p-3" placeholder="password" v-model="password"/>
        <button @click="login" class="bg-blue-600 w-1/2 p-3">Login</button>
        <button @click="$emit('close-login-widget')" class="bg-slate-700 w-1/2 p-3">Close</button>

        <p>{{ token }}</p>
      </div>
      <!-- Register -->
      <div v-else class="bg-slate-800 text-white w-full h-full text-center p-10 flex flex-col justify-center items-center gap-5">
        <h1 class="text-3xl font-bold">Register</h1>
        <input class="w-1/2 text-black p-3" placeholder="First name" v-model="firstname"/>
        <input class="w-1/2 text-black p-3" placeholder="Last name" v-model="lastname"/>
        <input class="w-1/2 text-black p-3" placeholder="email" v-model="email"/>
        <input class="w-1/2 text-black p-3" placeholder="password" v-model="password"/>
        <button @click="register" class="bg-blue-600 w-1/2 p-3">Register</button>
        <button @click="$emit('close-login-widget')" class="bg-slate-700 w-1/2 p-3">Close</button>
        <p>{{ token }}</p>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>