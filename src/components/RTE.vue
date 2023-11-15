<script setup>
/* eslint-disable */
import {Delta, QuillEditor} from "@vueup/vue-quill";
import {ref} from "vue";
const content = ref({});
const deltas = ref([]);
const EditorInstance = ref(null);
const print = ref("");
const deltastring = JSON.parse("{ \"delta\": { \"ops\": [ { \"insert\": \"Hello2o\" } ] }, \"oldContents\": { \"ops\": [ { \"insert\": \"\\n\" } ] }, \"source\": \"user\" }");
//const deltastring2 = JSON.parse("{ \"delta\": { \"ops\": [ { \"insert\": \"Hello2o\" } ] }, \"oldContents\": { \"ops\": [ { \"insert\": \"\\n\" } ] }, \"source\": \"user\" }");
let delta = new Delta(deltastring.delta.ops);

function applydelta() {
  EditorInstance.value.setContents(EditorInstance.value.getContents().compose(delta), 'api');
}
</script>

<template>
<QuillEditor @ready="()=> {EditorInstance.setContents(delta, 'user');}" ref="EditorInstance" toolbar="minimal" theme="snow" v-model:content="content.value" @textChange="(delta)=> {deltas.push(delta);}"></QuillEditor>
  <p>{{content}}</p>
  <button @click="applydelta">Update</button>
  <ul>
    <li v-for="delta in deltas" :key="delta.index">{{delta}}</li>
  </ul>
  <p>{{print}}</p>
</template>

<style scoped>

</style>