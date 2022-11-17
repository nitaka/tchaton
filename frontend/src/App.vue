<template>
  <div>
    <NavBar />
  </div>
<router-view :key="$route.fullPath"/>
</template>

<script>
// import navBar
import NavBar from "./components/NavBar.vue"

export default {
  components: {
    NavBar
  }
}
</script>

<style scoped lang="scss">

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

*, *:before, *:after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Open Sans', Helvetica, Arial, sans-serif;
  background: #b6b6b6;
}

input, button {
  border: none;
  outline: none;
  background: none;
  font-family: 'Open Sans', Helvetica, Arial, sans-serif;
}

</style>
