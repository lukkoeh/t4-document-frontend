<script setup>
import {onMounted, ref, defineExpose} from "vue";
import axios from "axios";
import {Delta} from "@vueup/vue-quill";
const current_document = ref(0);
const current_document_title = ref("Test");
const quilleditor = ref(null);
const token = ref(localStorage.getItem("token"));
const user_id = ref(localStorage.getItem("user_id"));
defineExpose({loadDocument});
onMounted(()=> {
  quilleditor.value.setContents(new Delta(), "api");
});

function resetQuill() {
  console.log("trying to reset")
  quilleditor.value.setContents(new Delta(), "api");
}
function loadDocument(doc) {
  //load the document and integrate all existing deltas from the db into the editor
  resetQuill();
  console.log(doc);
  console.log(user_id.value);
  current_document.value = doc.document_id;
  current_document_title.value = doc.document_title;
  let tempurl = "http://localhost:10001/deltas/" + doc.document_id;
  axios({
    method: "get",
    url: tempurl,
    headers: {
      "X-Auth-Token": token.value
    }
  }).then((res) => {
    // if there are no deltas, just use a blank editor
    if (res.data.length === 0) {
      return;
    }
    let deltas = res.data;
    let newdelta = new Delta();
    // apply the deltas to the newdelta
    for (let i = 0; i < deltas.length; i++) {
      newdelta = newdelta.compose(new Delta(JSON.parse(deltas[i].delta_content)));
    }
    console.log(newdelta);
    // set the editor contents to the newdelta
    quilleditor.value.setContents(newdelta, "api");
  }).catch(() => {
    console.log("error");
  });
}

function editorChanged(delta) {
  // handles change in the quill editor
  // check if the delta source is api
  if (delta.source === "api") {
    return;
  }
  console.log(quilleditor.value.getContents());
  // send the delta to the server
  let tempurl = "http://localhost:10001/delta/" + current_document.value;
  let formdata = new FormData();
  formdata.append("delta", JSON.stringify(delta.delta));
  axios({
    method: "post",
    url: tempurl,
    data: formdata,
    headers: {
      "X-Auth-Token": token.value
    }
  }).then((res) => {
    console.log(res.data);
  }).catch((err) => {
    console.log(err);
  });
}
</script>

<template>
  <div class="flex flex-col w-full h-full text-white">
    <h1 class="text-3xl m-5">Editing Document: {{current_document_title}}</h1>
    <QuillEditor ref="quilleditor" @textChange="(delta)=> {editorChanged(delta)}"></QuillEditor>
  </div>
</template>

<style scoped>

</style>